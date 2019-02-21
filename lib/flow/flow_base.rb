# frozen_string_literal: true

require_relative "flow/errors/state_invalid"

require_relative "flow/callbacks"
require_relative "flow/core"
require_relative "flow/operations"
require_relative "flow/trigger"

# A flow is a collection of procedurally executed operations sharing a common state.
class FlowBase
  include Technologic
  include Flow::Callbacks
  include Flow::Core
  include Flow::Operations
  include Flow::Trigger
end
