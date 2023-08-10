# frozen_string_literal: true

module RubyApm
  module Agent
    # An abstract adapter class to wrap supported APM agents
    class Adapter
      DEPENDENCIES = [].freeze

      def self.configure(agent_overrides)
        raise NotImplementedError
      end
    end
  end
end
