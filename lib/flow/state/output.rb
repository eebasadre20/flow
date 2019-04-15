# frozen_string_literal: true

# Output describe data which is created by operations during runtime and CANNOT be provided as part of the input.
module Flow
  module State
    module Output
      extend ActiveSupport::Concern

      included do
        class_attribute :_outputs, instance_writer: false, default: []

        delegate :_outputs, to: :class

        after_validation do
          next unless validated?

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
          ensure_validation_before output
          ensure_validation_before "#{output}=".to_sym
        end

        def ensure_validation_before(method)
          around_method method do |*arguments|
            raise Flow::State::Errors::NotValidated unless validated?

            super(*arguments)
          end
        end
      end

      def outputs
        return {} if _outputs.empty?

        Struct.new(*_outputs).new(*_outputs.map { |output| public_send(output) })
      end
    end
  end
end
