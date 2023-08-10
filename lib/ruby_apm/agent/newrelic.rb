# frozen_string_literal: true

module RubyApm
  module Agent
    # adapter for NewRelic APM agent
    class NewRelic < Adapter
      DEPENDENCIES = ['newrelic_rpm'].freeze

      class << self
        def configure(overrides)
          set_newrelic_config_path

          require 'new_relic/agent'
          agent = ::NewRelic::Agent
          agent.manual_start
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
