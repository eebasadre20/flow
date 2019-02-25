# frozen_string_literal: true

require_relative "flow/errors/state_invalid"

require_relative "operation/callbacks"
require_relative "operation/core"
require_relative "operation/error_handler"
require_relative "operation/execute"
require_relative "operation/failures"
require_relative "operation/rewind"
require_relative "operation/status"
require_relative "operation/transactions"

# Operations are service objects which are executed with a state.
class OperationBase
  include Technologic
  include Operation::Callbacks
  include Operation::Core
  include Operation::ErrorHandler
  include Operation::Execute
  include Operation::Failures
  include Operation::Rewind
  include Operation::Status
  include Operation::Transactions
end
