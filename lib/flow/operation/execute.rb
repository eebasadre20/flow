# frozen_string_literal: true

# Abstract placeholder for defining the behavior of the Operation. Child classes *must* implement `#execute`.
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
