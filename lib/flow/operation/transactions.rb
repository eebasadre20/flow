# frozen_string_literal: true

# It is best practice to have Operations which modify several persisted objects to use a transaction.
module Operation
  module Transactions
    extend ActiveSupport::Concern

    class_methods do
      def transaction_provider
        ActiveRecord::Base
      end

      private

      def wrap_in_transaction
        set_callback :behavior, :around, ->(_, block) { self.class.transaction_provider.transaction { block.call } }
      end
    end
  end
end
