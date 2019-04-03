# frozen_string_literal: true

# Operations take a state as input.
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
