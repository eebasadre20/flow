# frozen_string_literal: true

require_relative "state/errors/not_validated"

require_relative "state/status"
require_relative "state/output"

# A **State** is an aggregation of input and derived data.
module Flow
  class StateBase < Spicerack::InputModel
    include State::Status
    include State::Output
  end
end
