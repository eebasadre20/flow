# frozen_string_literal: true

# Output describe data which is created by operations during runtime and CANNOT be provided as part of the input.
module Flow
  module State
    module Output
      extend ActiveSupport::Concern

      included do
        class_attribute :_outputs, instance_writer: false, default: []

        after_validation do
          _outputs.each do |output|
            public_send("#{output}=".to_sym, _defaults[output].value) if _defaults.key?(output)
          end
        end
      end

      class_methods do
        def inherited(base)
          base._outputs = _outputs.dup
          super
        end

        private

        def output(output, default: nil, &block)
          _outputs << output
          define_attribute output
          define_default output, static: default, &block
          around_method output do
            raise Flow::State::Errors::NotValidated unless was_validated
          end
        end
      end
    end
  end
end
