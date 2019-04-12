# frozen_string_literal: true

# A state's attributes provide accessors to the input data it was initialized with.
module Flow
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

        private

        def define_attribute(attribute)
          _attributes << attribute

          attr_accessor attribute
          define_attribute_methods attribute
        end
        alias_method :attribute, :define_attribute
      end
    end
  end
end
