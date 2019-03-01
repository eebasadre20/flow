# frozen_string_literal: true

# It's best practice to have Flows in which nothing should be done unless everything is successful to use a transaction.
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
