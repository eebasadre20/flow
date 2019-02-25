# frozen_string_literal: true

# It is best practice to have Operations which modify several persisted objects to use a transaction.
module Operation
  module Transactions
    extend ActiveSupport::Concern

    METHODS_TO_TRANSACTION_WRAP = %i[behavior undo].freeze

    class_methods do
      def transaction_provider
        ActiveRecord::Base
      end

      private

      def wrap_in_transaction(only: nil, except: nil)
        whitelist = Array.wrap(only).map(&:to_sym)
        blacklist = Array.wrap(except).map(&:to_sym)

        methods_to_wrap = METHODS_TO_TRANSACTION_WRAP
        methods_to_wrap &= whitelist if whitelist.present?
        methods_to_wrap -= blacklist if blacklist.present?

        methods_to_wrap.each do |method_name|
          set_callback method_name, :around, ->(_, block) { self.class.transaction_provider.transaction { block.call } }
        end
      end
    end
  end
end
