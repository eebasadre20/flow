# frozen_string_literal: true

# The State status is used to ensure and enforce internal consistency.
module Flow
  module State
    module Status
      extend ActiveSupport::Concern

      included do
        after_validation { self.was_validated = errors.empty? }

        private

        attr_accessor :was_validated
      end

      def validated?
        was_validated.present?
      end
    end
  end
end
