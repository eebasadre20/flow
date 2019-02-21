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
  end
end
