# frozen_string_literal: true

require_relative "state/callbacks"
require_relative "state/attributes"
require_relative "state/arguments"
require_relative "state/options"
require_relative "state/core"
require_relative "state/string"

# A **State** is an aggregation of input and derived data.
module Flow
  class StateBase
    include ShortCircuIt
    include Technologic
    include ActiveModel::Model
    include Flow::State::Callbacks
    include Flow::State::Attributes
    include Flow::State::Arguments
    include Flow::State::Options
    include Flow::State::Core
    include Flow::State::String
  end
end
