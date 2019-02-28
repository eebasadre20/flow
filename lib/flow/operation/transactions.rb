# frozen_string_literal: true

# It's best practice to have Operations which modify several persisted objects to use a transaction.
module Operation
  module Transactions
    extend ActiveSupport::Concern

    CALLBACKS_FOR_TRANSACTIONS = %i[behavior undo].freeze

    included { include TransactionWrapper }
  end
end
