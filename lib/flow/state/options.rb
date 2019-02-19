# frozen_string_literal: true

# Options describe input which may be provided to define or override the initial state.
module State
  module Options
    extend ActiveSupport::Concern

    included do
      class_attribute :_options, instance_writer: false, default: {}

      set_callback :initialize, :after do
        _options.each { |option, info| __send__("#{option}=".to_sym, info.default_value) if public_send(option).nil? }
      end
    end

    class_methods do
      def inherited(base)
        dup = _options.dup
        base._options = dup.each { |k, v| dup[k] = v.dup }
        super
      end

      private

      def option(option, default: nil, &block)
        _options[option] = Option.new(default: default, &block)
        define_attribute option
      end
    end

    class Option
      def initialize(default:, &block)
        @default_value = (default.nil? && block_given?) ? block : default
      end

      def default_value
        return instance_eval(&@default_value) if @default_value.respond_to?(:call)

        @default_value
      end
    end
  end
end
