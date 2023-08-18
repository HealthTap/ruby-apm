# frozen_string_literal: true

require_relative 'lib/ruby_apm/version'
require_relative 'lib/ruby_apm/agent'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_apm'
  spec.version       = RubyApm::VERSION
  spec.authors       = ['Mike Collins']
  spec.email         = ['mike.collins@healthtap.com']

  spec.summary       = 'Abstract and centralize APM instrumentation & config amongst cluster of services.'
  spec.description   = <<~DESCRIPTION
    Intended to DRY up and abstract APM configurations between multiple ruby services in a cluster. Eventually, if we
    can separate out Consul agent / APP_CONFIG into its own gem, we can depend on that here and allow for more robust
    and dynamic configurations. I.e. we default to a root consul config per environment, which can be adjusted without
    needing to update gem or gemfile.lock revisions in services. With the current setup, services can point to Consul
    for any overrides, but this is specific to the service within a given environment, so we don't have the ability to
    set a default root configuration for an environment cluster without having to update the revision hash in dependent
    services.'
  DESCRIPTION

  spec.homepage = 'https://github.com/healthtap/ruby-apm/README.md'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['allowed_push_host'] = ''

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/healthtap/ruby-apm'
  spec.metadata['changelog_uri'] = 'https://github.com/healthtap/ruby-apm/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # TODO: add a build option to specify agent library
  spec.add_dependency('activesupport', '>= 6.0.0')

  RubyApm::Agent.adapter::DEPENDENCIES.each do |dependency|
    if dependency.is_a?(Array)
      spec.add_dependency(*dependency)
    else
      spec.add_dependency(dependency)
    end
  end
end
