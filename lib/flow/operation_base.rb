# frozen_string_literal: true

require_relative "flow/errors/state_invalid"

require_relative "operation/callbacks"
require_relative "operation/core"
require_relative "operation/execute"
require_relative "operation/failures"
require_relative "operation/status"

# Operations are service objects which are executed with a state.
class OperationBase
  include Technologic
  include Operation::Callbacks
  include Operation::Core
  include Operation::Execute
  include Operation::Failures
  include Operation::Status
end
