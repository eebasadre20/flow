# frozen_string_literal: true

RSpec.describe Operation::Transactions, type: :module do
  include_context "with an example operation", [ Operation::Execute, Operation::Transactions ]

  let(:transaction_provider) { ActiveRecord::Base }

  describe ".transaction_provider" do
    subject { example_operation_class.__send__(:transaction_provider) }

    it { is_expected.to eq transaction_provider }
  end

  describe ".wrap_in_transaction" do
    subject(:execute!) { example_operation.execute! }

    context "when not wrapped" do
      it "has no effect" do
        expect { execute! }.not_to change { transaction_provider.connection.open_transactions }
      end
    end

    context "when wrapped" do
      let!(:original_transaction_count) { transaction_provider.connection.open_transactions }

      before { example_operation_class.__send__(:wrap_in_transaction) }

      it "has changes the transactions" do
        allow(example_operation).to receive(:behavior) do
          expect(transaction_provider.connection.open_transactions).to eq original_transaction_count + 1
        end

        execute!
      end
    end
  end
end
