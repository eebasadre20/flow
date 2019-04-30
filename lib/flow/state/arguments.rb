# frozen_string_literal: true

# Arguments describe input required to define the initial state.
module Flow
  module State
    module Arguments
      extend ActiveSupport::Concern

      included do
        class_attribute :_arguments, instance_writer: false, default: []
        set_callback :initialize, :after do
          missing = _arguments.reject { |argument| input.key?(argument) }
          raise ArgumentError, "Missing #{"argument".pluralize(missing.length)}: #{missing.join(", ")}" if missing.any?
        end
      end

      class_methods do
        def inherited(base)
          base._arguments = _arguments.dup
          super
        end

        private

        def argument(argument)
          _arguments << argument
          define_attribute argument
        end
      end
    end
  end
end
