# frozen_string_literal: true

# When a `#revert` is called on a Flow, `#rewind` is called on Operations in reverse of the order they were executed.
module Flow
  module Ebb
    extend ActiveSupport::Concern

    included do
      set_callback(:initialize, :after) { @rewound_operations = [] }

      private

      attr_reader :rewound_operations
    end

    def ebb
      run_callbacks(:ebb) do
        executed_operations.reverse_each { |executed_operation| rewound_operations << executed_operation.rewind }
      end
    end
  end
end
