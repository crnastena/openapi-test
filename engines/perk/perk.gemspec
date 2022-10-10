# frozen_string_literal: true
require_relative "lib/perk/version"

Gem::Specification.new do |spec|
  spec.name = "perk"
  spec.version = Perk::VERSION
  spec.authors = ["Todor Rikic"]
  spec.email = ["trikic@icapitalnetwork.com"]
  spec.homepage = "https://www.icapitalnetwork.com"
  spec.summary = "Summary of Perk."
  spec.description = "Description of Perk."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "icapitalnetwork.com"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.3")

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_development_dependency "rspec-rails"

  spec.add_dependency "rails", ">= 7.0.3"
  spec.metadata["rubygems_mfa_required"] = "true"
end
