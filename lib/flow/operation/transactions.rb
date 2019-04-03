# frozen_string_literal: true

# Operations which modify several persisted objects together should use a transaction.
module Operation
  module Transactions
    extend ActiveSupport::Concern

    class_methods do
      def callbacks_for_transaction
        %i[behavior undo].freeze
      end
    end
  end
end
