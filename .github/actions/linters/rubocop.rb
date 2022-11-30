# frozen_string_literal: true

require "net/http"
require "json"
require "time"

@env_github_sha = ENV["GITHUB_SHA"]
@env_github_token = ENV["GITHUB_TOKEN"]

@env_pr_workspace = ENV["PR_WORKSPACE"]
@env_pr_repository = ENV["PR_REPOSITORY"]
@env_pr_number = ENV["PR_NUMBER"]
@env_run_on_pr_files_only = ENV.fetch("RUN_ON_PR_FILES_ONLY", "true").to_s.casecmp("true").zero?
@env_report_failure = ENV.fetch("REPORT_FAILURE", "false").to_s.casecmp("true").zero?

@check_name = "Rubocop"

@annotation_levels = {
  "refactor" => "failure",
  "convention" => "failure",
  "warning" => "warning",
  "error" => "failure",
  "fatal" => "failure",
}

@headers = {
  "Content-Type": "application/json",
  Accept: "application/vnd.github+json", # "application/vnd.github.antiope-preview+json",
  Authorization: "Bearer #{@env_github_token}",
}

@http = Net::HTTP.new("api.github.com", 443)
@http.use_ssl = true

# creates a check
def create_check
  body = {
    "name" => @check_name,
    "head_sha" => @env_github_sha,
    "status" => "in_progress",
    "started_at" => Time.now.iso8601,
  }

  path = "/repos/#{@env_pr_repository}/check-runs"
  resp = @http.post(path, body.to_json, @headers)

  puts "create_check response"
  puts resp

  raise resp.message if resp.code.to_i >= 300

  data = JSON.parse(resp.body)
  data["id"]
end

# updates a check
def update_check(id, conclusion, output)
  max_annotations = 50
  annotations = if output.nil?
      []
    else
      output["annotations"]
    end

  if annotations.size > max_annotations
    # loop over annotations
    pages = annotations.size / 50
    page = 1
    while page <= pages
      current_annotations = annotations.take(max_annotations)
      annotations = annotations - current_annotations
      page_output = {
        title: output[:title],
        summary: output[:summary],
        text: output[:text],
        "annotations" => current_annotations,
      }
      body = {
        "name" => @check_name,
        "head_sha" => @env_github_sha,
        "status" => "in_progress",
        "conclusion" => conclusion,
        "output" => page_output,
      }

      if page == pages
        body = body.merge({ status: "completed", "completed_at" => Time.now.iso8601 })
      end

      path = "/repos/#{@env_pr_repository}/check-runs/#{id}"
      resp = @http.patch(path, body.to_json, @headers)

      puts "update_check page: #{page} response"
      puts resp

      raise resp.message if resp.code.to_i >= 300

      page += 1
    end
  else
    body = {
      "name" => @check_name,
      "head_sha" => @env_github_sha,
      "status" => "completed",
      "completed_at" => Time.now.iso8601,
      "conclusion" => conclusion,
      "output" => output,
    }

    path = "/repos/#{@env_pr_repository}/check-runs/#{id}"
    resp = @http.patch(path, body.to_json, @headers)
    puts "update_check response"
    puts resp

    raise resp.message if resp.code.to_i >= 300
  end
end

# get list of PR files to pass to rubocop
def get_pr_files
  return "" unless @env_run_on_pr_files_only

  repo_url = "/repos/#{@env_pr_repository}/pulls/#{@env_pr_number}/files"
  file_pattern = /\.r[bu]$|\/bundle$|\/setup$|\/rails$|\/rake$|\/?Gemfile$|\/?Rakefile$|\.gemspec$|\.rake$/
  page = 1

  has_data = true
  results = []

  while has_data
    path = "#{repo_url}?page=#{page}"
    resp = @http.get(path, @headers)
    raise resp.message if resp.code.to_i >= 300

    data = JSON.parse(resp.body)
    has_data = !data.empty?
    page += 1
    data.each do |i|
      results << i["filename"] if i["filename"]&.match?(file_pattern)
    end
  end

  results.join(" ")
end

# runs rubocop
def run_rubocop
  output = nil
  Dir.chdir(@env_pr_workspace) do
    files = get_pr_files
    result = `bundle exec rubocop --format json #{files}`
    output = JSON.parse(result)
  end

  count = 0
  conclusion = "success"
  annotations = []

  # RuboCop reports the number of errors found in "offense_count"
  offense_count = output["summary"]["offense_count"]
  if offense_count != 0
    output["files"].each do |file|
      path = file["path"]
      offenses = file["offenses"]

      offenses.each do |offense|
        severity = offense["severity"]
        message = offense["message"]
        start_line = offense["location"]["start_line"]
        end_line = offense["location"]["last_line"]
        start_column = offense["location"]["start_column"]
        end_column = offense["location"]["last_column"]
        annotation_level = @annotation_levels[severity]

        conclusion = "failure" if annotation_level == "failure"

        # Create a new annotation for each error
        annotation = {
          "path" => path,
          "start_line" => start_line,
          "end_line" => end_line,
          annotation_level: annotation_level,
          "message" => message,
        }

        # Annotations only support start and end columns on the same line
        if start_line == end_line
          annotation.merge({ "start_column" => start_column, "end_column" => end_column })
        end

        annotations.push(annotation)

        count += 1
      end
    end

    conclusion = "neutral" unless @env_report_failure
  end

  raise "Count mismatch expected #{offense_count} got #{count}" if offense_count != count

  {
    annotations: annotations,
    count: count,
    conclusion: conclusion,
  }
end

# main method, that runs the whole thing
def run
  id = create_check
  update_check_ran = false

  begin
    results = run_rubocop
    conclusion = results[:conclusion]
    count = results[:count]
    annotations = results[:annotations]

    output = {
      title: @check_name,
      summary: "#{count} offense(s) found",
      text: "#{count} offense(s) found (text)",
      "annotations" => annotations,
    }

    update_check(id, conclusion, output)
    update_check_ran = true

    # Print offenses
    puts output[:summary]
    annotations.each do |annotation|
      puts "#{annotation["path"]}:#{annotation["start_line"]}:#{annotation["end_line"]}: #{annotation["message"]}\n"
    end

    if conclusion == "failure"
      raise "Rubocop found offenses"
    end
  rescue StandardError
    unless update_check_ran
      conclusion = if @env_report_failure
          "failure"
        else
          "neutral"
        end
      update_check(id, conclusion, nil)
    end

    raise
  end
end

run
