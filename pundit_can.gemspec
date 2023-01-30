require_relative "lib/pundit_can/version"

Gem::Specification.new do |spec|
  spec.name = "pundit_can"
  spec.version = PunditCan::VERSION
  spec.authors = ["candland"]
  spec.email = ["candland@gmail.com"]
  spec.homepage = "https://candland.net/pundit_can"
  spec.summary = "Add cancan like load and authorize to controllers."
  spec.description = "Add cancan like load and authorize to controllers."
  spec.license = "MIT"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/candland/pundit_can"
  spec.metadata["changelog_uri"] = "https://github.com/candland/pundit_can/CHANGES.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4.2"
  spec.add_dependency "pundit", ">= 2.0.0"

  spec.add_development_dependency "rails-controller-testing"
end
