# frozen_string_literal: true

# Options describe input which may be provided to define or override the initial state.
module Flow
  module State
    module Options
      extend ActiveSupport::Concern

      included do
        class_attribute :_options, instance_writer: false, default: []
      end

      class_methods do
        def inherited(base)
          base._options = _options.dup
          super
        end

        private

        def option(option, default: nil, &block)
          _options << option
          define_default option, static: default, &block
          define_attribute option
        end
      end
    end
  end
end
