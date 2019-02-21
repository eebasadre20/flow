# frozen_string_literal: true

# Arguments describe input required to define the initial state.
module Flow
  module Operations
    extend ActiveSupport::Concern

    included do
      class_attribute :_operations, instance_writer: false, default: []

      delegate :_operations, to: :class
    end

    class_methods do
      def inherited(base)
        base._operations = _operations.dup
        super
      end

      private

      def operations(*operations)
        _operations.concat(operations.flatten)
      end
    end
  end
end
