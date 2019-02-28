# frozen_string_literal: true

# It's best practice to have Flows in which nothing should be done unless everything is successful to use a transaction.
module Flow
  module Transactions
    extend ActiveSupport::Concern

    CALLBACKS_FOR_TRANSACTIONS = %i[flux ebb].freeze

    included { include TransactionWrapper }
  end
end
