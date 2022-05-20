require_relative "lib/breaker/version"

Gem::Specification.new do |spec|
  spec.name        = "breaker"
  spec.version     = Breaker::VERSION
  spec.authors     = ["Todor Rikic"]
  spec.email       = ["trikic@icapitalnetwork.com"]
  spec.homepage    = "https://www.icapitalnetwork.com"
  spec.summary     = "Summary of Breaker."
  spec.description = "Description of Breaker."
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "icapitalnetwork.com"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.3"
end
