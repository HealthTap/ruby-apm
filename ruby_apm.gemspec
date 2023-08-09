require_relative 'lib/ruby_apm/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-apm"
  spec.version       = RubyApm::VERSION
  spec.authors       = ["Mike Collins"]
  spec.email         = ["mike.collins@healthtap.com"]

  spec.summary       = "Abstract instrumentation and centralize amongst connected services" # TODO
  spec.description   = "Abstract instrumentation and centralize amongst connected services" # TODO
  spec.homepage      = "https://github.com/healthtap" # TODO
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/healthtap" # TODO
  spec.metadata["changelog_uri"] = "https://github.com/healthtap" # TODO

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # TODO: add a build option to specify agent library
  spec.add_dependency('newrelic_rpm')
end
