# frozen_string_literal: true

# Operations take a state as input.
module Flow
  module Operation
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :state

        delegate :state_proxy_class, to: :class
      end

      class_methods do
        def state_proxy_class
          ivar_name = attr_internal_ivar_name(__method__)

          unless instance_variable_defined?(ivar_name)
            delegate_method_names = _state_writers.map { |method_name| "#{method_name}=" } + _state_readers

            proxy_class = Class.new(Flow::StateProxy)
            proxy_class.delegate(*delegate_method_names, to: :state) if delegate_method_names.any?

            instance_variable_set(ivar_name, proxy_class)
          end

          instance_variable_get(ivar_name)
        end
      end

      def initialize(state)
        @state = state_accessors? ? state_proxy_class.new(state) : state
      end
    end
  end
end
