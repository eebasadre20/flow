# frozen_string_literal: true

# Arguments describe input required to define the initial state.
module State
  module Arguments
    extend ActiveSupport::Concern

    included do
      class_attribute :_arguments, instance_writer: false, default: []
      set_callback :initialize, :after do
        missing = _arguments.select { |argument| public_send(argument).nil? }
        raise ArgumentError, "Missing #{"argument".pluralize(missing.length)}: #{missing.join(", ")}" if missing.any?
      end
    end

    class_methods do
      def inherited(base)
        base._arguments = _arguments.dup
        super
      end

      protected

      def argument(argument)
        _arguments << argument
        define_attribute argument
      end
    end
  end
end
