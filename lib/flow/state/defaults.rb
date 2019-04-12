# frozen_string_literal: true

# Defaults allow attributes to be initialized with a value if none have been provided.
module Flow
  module State
    module Defaults
      extend ActiveSupport::Concern

      included do
        class_attribute :_defaults, instance_writer: false, default: {}

        set_callback :initialize, :after do
          _defaults.each do |attribute, info|
            public_send("#{attribute}=".to_sym, info.value.dup) if public_send(attribute).nil?
          end
        end
      end

      class_methods do
        def inherited(base)
          dup = _defaults.dup
          base._defaults = dup.each { |k, v| dup[k] = v.dup }
          super
        end

        private

        def define_default(attribute, static: nil, &block)
          _defaults[attribute] = Value.new(static: static, &block)
        end
      end

      class Value
        def initialize(static:, &block)
          @value = (static.nil? && block_given?) ? block : static
        end

        def value
          return instance_eval(&@value) if @value.respond_to?(:call)

          @value
        end
      end
    end
  end
end
