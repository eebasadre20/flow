# frozen_string_literal: true

# A **StateProxy** adapts a **State** to an **Operation** through an Operation's `state_*` accessors.
module Flow
  class StateProxy
    def initialize(state)
      @state = state
    end

    private

    attr_reader :state
  end
end
