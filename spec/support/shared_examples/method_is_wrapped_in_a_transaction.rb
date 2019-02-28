# frozen_string_literal: true

RSpec.shared_examples_for "method is wrapped in a transaction" do |trigger_method, callback, method = callback|
  subject(:trigger) { example_instance.public_send(trigger_method) }

  context "when not wrapped" do
    before { example_class.__send__(:wrap_in_transaction, except: callback) }

    it "has no effect" do
      expect { trigger }.not_to change { transaction_provider.connection.open_transactions }
    end
  end

  context "when wrapped" do
    let!(:original_transaction_count) { transaction_provider.connection.open_transactions }

    before { example_class.__send__(:wrap_in_transaction, only: callback) }

    it "has changes the transactions" do
      allow(example_instance).to receive(method) do
        expect(transaction_provider.connection.open_transactions).to eq original_transaction_count + 1
      end

      trigger
    end
  end
end
