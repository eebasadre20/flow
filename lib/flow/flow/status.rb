# frozen_string_literal: true

# The Flow status is a summary of what has occurred during the runtime, used mainly for analysis and program flow.
module Flow
  module Status
    extend ActiveSupport::Concern

    def pending?
      executed_operations.none?
    end

    def triggered?
      executed_operations.any?
    end

    def success?
      triggered? && (operation_instances - executed_operations).none?
    end

    def failed?
      executed? && !success?
    end

    def reverted?
      rewound_operations.any?
    end
  end
end
