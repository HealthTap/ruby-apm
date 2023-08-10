# frozen_string_literal: true

require 'ruby_apm/version'
require 'ruby_apm/agent'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/deep_merge'

# Generic APM agent to be shared amongst services
module RubyApm
  # handles things like app_name, chosen agent, overrides, etc.
  class Config
    attr_accessor :app_name

    # overrides for APM agent config - we could abstract this, but feature sets may differ
    Agent::ALL.each do |agent|
      attr_accessor agent # overrides
    end

    def initialize(app_name: nil, **overrides)
      @app_name = app_name || Rails.application.class.module_parent_name if defined?(Rails)

      Agent::ALL.each do |agent|
        instance_variable_set("@#{agent}", (overrides[agent] || {}).with_indifferent_access)
      end
    end
  end

  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
      Agent.adapter.configure(config.send(Agent::ACTIVE))
      config
    end
  end
end
