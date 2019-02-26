# frozen_string_literal: true

# When `#trigger` is called on a Flow, `#execute` is called on Operations sequentially in their given order.
module Flow
  module Flux
    extend ActiveSupport::Concern

    included do
      set_callback(:initialize, :after) { @executed_operations = [] }

      attr_reader :failed_operation

      private

      attr_reader :executed_operations
    end

    def failed_operation?
      failed_operation.present?
    end

    def flux
      flux!
    rescue StandardError => exception
      error :error_executing_operation, state: state, exception: exception

      revert
    end

    def flux!
      run_callbacks(:flux) do
        _operations.each do |operation|
          executed_operation = operation.execute(state)

          (@failed_operation = executed_operation) and raise Flow::Flux::Failure if executed_operation.failed?

          executed_operations << executed_operation
        end
      end
    end

    class Failure < StandardError; end
  end
end
