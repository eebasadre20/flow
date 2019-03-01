# frozen_string_literal: true

# Reverting a Flow rewinds all its executed operations in reverse order (see `Flow::Ebb`).
module Flow
  module Revert
    extend ActiveSupport::Concern

    included do
      set_callback :revert, :around, ->(_, block) { surveil(:revert) { block.call } }
    end

    def revert
      run_callbacks(:revert) { ebb }

      state
    end
  end
end
