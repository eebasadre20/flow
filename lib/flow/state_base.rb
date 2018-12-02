# frozen_string_literal: true

require_relative "state/callbacks"
require_relative "state/attributes"
require_relative "state/arguments"
require_relative "state/options"
require_relative "state/core"
require_relative "state/string"

# A flow state is the immutable structure of relevant data.
class StateBase
  include ActiveModel::Model
  include State::Callbacks
  include State::Attributes
  include State::Arguments
  include State::Options
  include State::Core
  include State::String
end
