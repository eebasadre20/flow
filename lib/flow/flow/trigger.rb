# frozen_string_literal: true

# Triggering a Flow executes all its operations in sequential order *iff* it has a valid state.
module Flow
  module Trigger
    extend ActiveSupport::Concern

    class_methods do
      def trigger!(*arguments)
        new(*arguments).trigger!
      end

      def trigger(*arguments)
        new(*arguments).trigger
      end
    end

    included do
      delegate :valid?, to: :state, prefix: true

      set_callback :trigger, :around, ->(_, block) { surveil(:trigger) { block.call } }
    end

    def trigger!
      raise Flow::Errors::StateInvalid unless state_valid?

      run_callbacks(:trigger) do
        _operations.each { |operation| surveil(operation.name) { operation.execute(state) } }
      end

      state
    end

    def trigger
      trigger!
    rescue Flow::Errors::StateInvalid
      nil
    end
  end
end
