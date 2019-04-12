# frozen_string_literal: true

# A callback driven approach to wrap business logic within database transaction.
module Flow
  module TransactionWrapper
    extend ActiveSupport::Concern

    class_methods do
      def transaction_provider
        ActiveRecord::Base
      end

      private

      def callbacks_to_wrap(only: nil, except: nil)
        whitelist = Array.wrap(only).map(&:to_sym)
        blacklist = Array.wrap(except).map(&:to_sym)

        callbacks_to_wrap = callbacks_for_transaction
        callbacks_to_wrap &= whitelist if whitelist.present?
        callbacks_to_wrap -= blacklist if blacklist.present?
        callbacks_to_wrap
      end

      def wrap_in_transaction(only: nil, except: nil)
        callbacks_to_wrap(only: only, except: except).each do |method_name|
          set_callback method_name, :around, ->(_, block) { self.class.transaction_provider.transaction { block.call } }
        end
      end
    end
  end
end
