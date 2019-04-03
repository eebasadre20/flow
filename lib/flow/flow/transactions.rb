# frozen_string_literal: true

# Flows where no operation should be persisted unless all are successful should use a transaction.
module Flow
  module Transactions
    extend ActiveSupport::Concern

    class_methods do
      def callbacks_for_transaction
        %i[flux ebb].freeze
      end
    end
  end
end
