require "apm/version"

module Apm
  class Config
    attr_accessor :app_name
    # overrides for APM agent config - we could abstract this, but feature sets may differ
    attr_accessor :newrelic
    attr_accessor :agent
    # i.e.:
    # attr_accessor :datadog
    # attr_accessor :sumologic
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure(&block)
    yield(config)
    config.app_name ||= Rails.application.class.module_parent_name if defined?(Rails)
    configure_agent
    config
  end

  def self.configure_agent
    case config.agent
    when :newrelic
      config.newrelic ||= {}
      require 'newrelic_rpm'

      control_instance = NewRelic::Control.instance
      def control_instance.config_file_path
        "#{File.dirname(__FILE__)}/../config/newrelic.yml"
      end

      control_instance.init_plugin
      agent = NewRelic::Agent
      agent.config.replace_or_add_config(
        agent::Configuration::ManualSource.new(config.newrelic)
      )
    else
      raise NotImplementedError('Unrecognized APM agent')
    end
  end
end

