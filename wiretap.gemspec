# frozen_string_literal: true

require_relative "lib/wiretap/version"

Gem::Specification.new do |spec|
  spec.name = "wiretap"
  spec.version = Wiretap::VERSION
  spec.authors = ["James Wozniak"]
  spec.email = ["wozza35@hotmail.com"]

  spec.summary = "A tool to monitor and record method calls on Ruby objects."
  spec.description = "Wiretap is a Ruby gem that allows you to wrap any object and monitor the method calls made to it, including arguments, return values, and yielded values from blocks."
  spec.homepage = "https://www.github.com/wozza35/wiretap"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
