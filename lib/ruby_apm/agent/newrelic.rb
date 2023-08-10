# frozen_string_literal: true

module RubyApm
  module Agent
    # adapter for NewRelic APM agent
    class NewRelic < Adapter
      DEPENDENCIES = ['newrelic_rpm'].freeze

      if defined?(Rails)
        # tracers for Rails apps
        class Railtie < Rails::Railtie
          initializer 'newrelic_rpm.include_method_tracers', before: :load_config_initializers do
            Module.include(::NewRelic::Agent::MethodTracer::ClassMethods)
            Module.include(::NewRelic::Agent::MethodTracer)
          end
        end
      end

      class << self
        def configure(overrides)
          set_newrelic_config_path

          agent = ::NewRelic::Agent
          ::NewRelic::Control.instance.init_plugin(
            { agent_enabled: true }.merge(defined?(Rails) ? { config: ::Rails.configuration } : {})
          )
          environment_overrides = overrides[::NewRelic::Control.instance.env] || {}
          agent.config.replace_or_add_config(
            agent::Configuration::ManualSource.new(
              # override non-environment specific options
              overrides.deep_merge(environment_overrides)
            )
          )
        end

        private

        def set_newrelic_config_path
          require 'new_relic/control'
          control_instance = ::NewRelic::Control.instance
          def control_instance.config_file_path
            "#{File.dirname(__FILE__)}/../../../config/newrelic.yml"
          end
        end
      end
    end
  end
end
