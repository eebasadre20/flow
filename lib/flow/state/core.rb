# frozen_string_literal: true

# Accepts input representing the arguments and input which define the initial state.
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
