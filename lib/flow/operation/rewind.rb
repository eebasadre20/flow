# frozen_string_literal: true

# When something goes wrong in Flow, `#rewind` is called on all executed Operations to `#undo` their behavior.
module Operation
  module Rewind
    extend ActiveSupport::Concern

    included do
      set_callback :rewind, :around, ->(_, block) { surveil(:rewind) { block.call } }
    end

    def rewind
      run_callbacks(:rewind) do
        run_callbacks(:undo) { undo }
      end
    end

    def undo
      # abstract method which should be defined by descendants to undo the functionality of the `#behavior` method
    end
  end
end
