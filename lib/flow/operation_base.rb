# frozen_string_literal: true

require_relative "operation/core"
require_relative "operation/execute"

# Operations are service objects which are executed with a state.
class OperationBase
  include Technologic
  include Operation::Core
  include Operation::Execute
end
