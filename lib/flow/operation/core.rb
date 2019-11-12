# frozen_string_literal: true

# Operations take a state as input.
module Flow
  module Operation
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :state
      end

      def initialize(state)
        @state = StateProxy.new(state, _state_readers, _state_writers)
      end
    end
  end
end
