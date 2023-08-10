# frozen_string_literal: true

require_relative 'agent/adapter'
require_relative 'agent/newrelic'

module RubyApm
  # root module representing supported APM agents and associated functionality
  module Agent
    NEW_RELIC = :newrelic
    ALL = [NEW_RELIC].freeze
    ACTIVE = ENV['RUBY_APM_AGENT'] || NEW_RELIC

    def self.adapter
      case ACTIVE
      when NEW_RELIC
        NewRelic
      else
        raise NotImplementedError, "Unrecognized APM agent: #{ACTIVE}"
      end
    end
  end
end
