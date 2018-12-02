# frozen_string_literal: true

# Defines the immutable structure by defining attribute accessors for the state data.
module State
  module Attributes
    extend ActiveSupport::Concern

    included do
      include ActiveModel::AttributeMethods

      class_attribute :_attributes, instance_writer: false, default: []
    end

    class_methods do
      def inherited(base)
        base._attributes = _attributes.dup
        super
      end

      protected

      def define_attribute(attribute)
        _attributes << attribute

        attr_accessor attribute
        define_attribute_methods attribute
        protected "#{attribute}=".to_sym
      end
    end
  end
end
