# frozen_string_literal: true

# Accepts input representing the arguments and options which define the initial state.
module Flow
  module Core
    extend ActiveSupport::Concern

    class_methods do
      def state_class
        "#{name.chomp("Flow")}State".constantize
      end
    end

    included do
      delegate :state_class, to: :class
      delegate :outputs, to: :state

      attr_reader :state
    end

    def initialize(**input)
      run_callbacks(:initialize) { @state = state_class.new(**input) }
    end
  end
end
