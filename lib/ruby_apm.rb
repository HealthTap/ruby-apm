# frozen_string_literal: true

require 'ruby_apm/version'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/deep_merge'

# Generic APM agent to be shared amongst services
module RubyApm
  # handles things like app_name, chosen agent, overrides, etc.
  class Config
    attr_accessor :app_name, :agent
    # overrides for APM agent config - we could abstract this, but feature sets may differ
    attr_accessor :newrelic

    # i.e.:
    # attr_accessor :datadog
    # attr_accessor :sumologic

    def initialize(app_name: nil, agent: nil, newrelic: {})
      @app_name = app_name || Rails.application.class.module_parent_name if defined?(Rails)
      @agent = agent
      @newrelic = newrelic.with_indifferent_access
    end
  end

  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
      configure_agent
      config
    end

    def configure_agent
      case config.agent
      when :newrelic
        configure_newrelic
      else
        raise NotImplementedError('Unrecognized APM agent')
      end
    end

    def configure_newrelic
      require 'new_relic/agent'

      control_instance = NewRelic::Control.instance
      def control_instance.config_file_path
        "#{File.dirname(__FILE__)}/../config/newrelic.yml"
      end

      agent = NewRelic::Agent
      agent.manual_start
      agent.config.replace_or_add_config(
        agent::Configuration::ManualSource.new(
          config.newrelic.deep_merge(config.newrelic[control_instance.env] || {})
        )
      )
    end
  end
end
