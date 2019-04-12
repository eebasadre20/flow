# frozen_string_literal: true

# A state accepts input represented by arguments and options which initialize it.
module Flow
  module State
    module Core
      extend ActiveSupport::Concern

      def initialize(**input)
        run_callbacks(:initialize) do
          input.each { |key, value| __send__("#{key}=".to_sym, value) }
        end
      end
    end
  end
end
