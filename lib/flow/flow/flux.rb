# frozen_string_literal: true

# When `#trigger` is called on a Flow, `#execute` is called on Operations sequentially in their given order.
module Flow
  module Flux
    extend ActiveSupport::Concern

    included do
      set_callback(:initialize, :after) { @executed_operations = [] }

      private

      attr_reader :executed_operations, :failed_operation
    end

    def failed_operation?
      failed_operation.present?
    end

    private

    def flux
      run_callbacks(:flux) do
        _operations.each do |operation|
          executed_operation = operation.execute(state)

          @failed_operation = executed_operation if executed_operation.failed?
          raise Flow::Flux::Failure if failed_operation?

          executed_operations << executed_operation
        end
      end
    rescue StandardError => exception
      error :error_executing_operation, operation: operation, state: state, exception: exception

      revert
    end

    class Failure < StandardError; end
  end
end
