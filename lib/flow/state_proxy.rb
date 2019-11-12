# frozen_string_literal: true

# A **StateProxy** adapts a **State** to an **Operation** by enforcing the use of the Operation's `state_*` accessors.
module Flow
  class StateProxy < Spicerack::RootObject
    def initialize(state, state_readers, state_writers)
      @state = state
      @state_readers = state_readers
      @state_writers = state_writers
    end

    def method_missing(method_name, *arguments, &block)
      return super unless valid_delegation?(method_name)

      state.public_send(method_name, *arguments, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      valid_delegation?(method_name) || super
    end

    private

    attr_reader :state, :state_readers, :state_writers

    def blank?
      state_readers.blank? && state_writers.blank?
    end

    def valid_delegation?(method_name)
      return false unless state.respond_to?(method_name)

      # Support for implicit state delegation (those without the use of accessors) will be removed in a future version.
      # To preserve current behavior until then, if no accessors are used, allow it but complain about it also.
      if blank?
        ActiveSupport::Deprecation.warn("Implicit use of `state.#{method_name}` to be removed. Use state accessors.")
        return true
      end

      method_name_str = method_name.to_s
      return state_writers.include?(method_name_str.delete_suffix("=").to_sym) if method_name_str.end_with?("=")

      state_readers.include?(method_name)
    end
  end
end
