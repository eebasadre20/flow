# frozen_string_literal: true

# The Operation status is used by the Flow calling it to determine what to do next; continue on or stop and rollback.
module Operation
  module Status
    extend ActiveSupport::Concern

    included do
      set_callback(:execute, :before) { self.was_executed = true }
      set_callback(:rewind, :before) { self.was_rewound = true }

      private

      attr_accessor :was_executed, :was_rewound
    end

    def executed?
      was_executed.present?
    end

    def rewound?
      was_rewound.present?
    end

    def failed?
      operation_failure.present?
    end

    def success?
      executed? && !failed?
    end
  end
end
