# frozen_string_literal: true

# Formats the state as a string.
module State
  module String
    extend ActiveSupport::Concern

    delegate :name, to: :class, prefix: true

    def to_s
      string_for(__method__)
    end

    def inspect
      string_for(__method__)
    end

    protected

    def stringable_attributes
      self.class._attributes
    end

    private

    def string_for(method)
      "#<#{class_name} #{attribute_string(method)}>"
    end

    def attribute_string(method)
      stringable_attribute_values.map { |attribute, value| "#{attribute}=#{value.public_send(method)}" }.join(" ")
    end

    def stringable_attribute_values
      stringable_attributes.each_with_object({}) { |attribute, result| result[attribute] = public_send(attribute) }
    end
  end
end
