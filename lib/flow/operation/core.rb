# frozen_string_literal: true

# Accepts input representing the state.
module Operation
  module Core
    extend ActiveSupport::Concern

    included do
      attr_reader :state
    end

    def initialize(state)
      @state = state
    end
  end
end
