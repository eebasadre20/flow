# frozen_string_literal: true

# Abstract placeholder for defining the behavior of the Operation. Child classes *must* implement `#execute`.
module Operation
  module Execute
    extend ActiveSupport::Concern

    included do
      attr_reader :operation_failure

      set_callback :execute, :around, ->(_, block) { surveil(:execute) { block.call } }
    end

    class_methods do
      def execute!(*arguments)
        new(*arguments).execute!
      end

      def execute(*arguments)
        new(*arguments).execute
      end
    end

    def execute!
      run_callbacks(:execute) { behavior }
    end

    def execute
      execute!
    rescue Operation::Failures::OperationFailure => exception
      @operation_failure = exception
      false
    end

    def behavior
      # abstract method which should be defined by descendants with the functionality of the given operation
    end
  end
end
