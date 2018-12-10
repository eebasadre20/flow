# frozen_string_literal: true

# Execute the operation.
module Operation
  module Execute
    extend ActiveSupport::Concern

    class_methods do
      def execute(*arguments)
        new(*arguments).execute
      end
    end

    def execute
      raise NotImplementedError
    end

    included do
      include AroundTheWorld
      include Technologic

      around_method :execute, prevent_double_wrapping_for: Technologic do
        surveil(:execute) { super() }
      end
    end
  end
end
