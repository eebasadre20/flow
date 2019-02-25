# frozen_string_literal: true

RSpec.describe Operation::Transactions, type: :module do
  include_context "with an example operation", [ Operation::Execute, Operation::Rewind, Operation::Transactions ]

  let(:transaction_provider) { ActiveRecord::Base }

  describe ".transaction_provider" do
    subject { example_operation_class.__send__(:transaction_provider) }

    it { is_expected.to eq transaction_provider }
  end

  describe ".wrap_in_transaction" do
    subject(:wrap_in_transaction) { example_operation_class.__send__(:wrap_in_transaction, **options) }

    let(:options) do
      {}
    end

    shared_examples_for "methods are wrapped in a transaction" do
      before do
        allow(example_operation_class).to receive(:set_callback).and_call_original
        wrap_in_transaction
      end

      let(:expected_no_wrapped_methods) { methods_to_transaction_wrap - expected_wrapped_methods }

      it "wraps expected methods" do
        expected_no_wrapped_methods.each do |method_name|
          expect(example_operation_class).not_to have_received(:set_callback).with(method_name, :around)
        end

        expected_wrapped_methods.each do |method_name|
          expect(example_operation_class).to have_received(:set_callback).with(method_name, :around, instance_of(Proc))
        end
      end
    end

    shared_examples_for "methods are wrapped in a transaction with a variety of input" do
      let(:methods_to_transaction_wrap) { described_class::METHODS_TO_TRANSACTION_WRAP }
      let(:expected_wrapped_methods) { described_class::METHODS_TO_TRANSACTION_WRAP }

      let(:listing_type) { nil }
      let(:test_value) { nil }

      let(:options) do
        { listing_type.to_sym => value }
      end

      context "when string" do
        let(:value) { test_value.to_s }

        it_behaves_like "methods are wrapped in a transaction"
      end

      context "when symbol" do
        let(:value) { test_value.to_sym }

        it_behaves_like "methods are wrapped in a transaction"
      end

      context "when array of strings" do
        let(:value) { Array.wrap(test_value).map(&:to_s) }

        it_behaves_like "methods are wrapped in a transaction"
      end

      context "when array of symbols" do
        let(:value) { Array.wrap(test_value).map(&:to_sym) }

        it_behaves_like "methods are wrapped in a transaction"
      end
    end

    context "when only: is specified" do
      context "with invalid method" do
        it_behaves_like "methods are wrapped in a transaction with a variety of input" do
          let(:expected_wrapped_methods) { [] }
          let(:listing_type) { :only }
          let(:test_value) { Faker::Internet.domain_word }
        end
      end

      context "with valid method" do
        it_behaves_like "methods are wrapped in a transaction with a variety of input" do
          let(:expected_wrapped_methods) { [ test_value ] }
          let(:listing_type) { :only }
          let(:test_value) { described_class::METHODS_TO_TRANSACTION_WRAP.sample }
        end
      end
    end

    context "when except: is specified" do
      context "with invalid method" do
        it_behaves_like "methods are wrapped in a transaction with a variety of input" do
          let(:listing_type) { :except }
          let(:test_value) { Faker::Internet.domain_word }
        end
      end

      context "with valid method" do
        it_behaves_like "methods are wrapped in a transaction with a variety of input" do
          let(:expected_wrapped_methods) { described_class::METHODS_TO_TRANSACTION_WRAP.without(test_value) }
          let(:listing_type) { :except }
          let(:test_value) { described_class::METHODS_TO_TRANSACTION_WRAP.sample }
        end
      end
    end

    context "when executing" do
      subject(:execute!) { example_operation.execute! }

      context "when not wrapped" do
        before { example_operation_class.__send__(:wrap_in_transaction, except: :behavior) }

        it "has no effect" do
          expect { execute! }.not_to change { transaction_provider.connection.open_transactions }
        end
      end

      context "when wrapped" do
        let!(:original_transaction_count) { transaction_provider.connection.open_transactions }

        before { example_operation_class.__send__(:wrap_in_transaction, only: :behavior) }

        it "has changes the transactions" do
          allow(example_operation).to receive(:behavior) do
            expect(transaction_provider.connection.open_transactions).to eq original_transaction_count + 1
          end

          execute!
        end
      end
    end

    context "when rewinding" do
      subject(:rewind) { example_operation.rewind }

      context "when not wrapped" do
        before { example_operation_class.__send__(:wrap_in_transaction, except: :undo) }

        it "has no effect" do
          expect { rewind }.not_to change { transaction_provider.connection.open_transactions }
        end
      end

      context "when wrapped" do
        let!(:original_transaction_count) { transaction_provider.connection.open_transactions }

        before { example_operation_class.__send__(:wrap_in_transaction, only: :undo) }

        it "has changes the transactions" do
          allow(example_operation).to receive(:undo) do
            expect(transaction_provider.connection.open_transactions).to eq original_transaction_count + 1
          end

          rewind
        end
      end
    end
  end
end
