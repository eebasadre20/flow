# frozen_string_literal: true

RSpec.shared_examples_for "a transaction wrapper" do
  it { is_expected.to include_module TransactionWrapper }

  describe "CALLBACKS_FOR_TRANSACTIONS" do
    subject { described_class::CALLBACKS_FOR_TRANSACTIONS }

    it { is_expected.to all(be_a(Symbol)) }
  end

  let(:transaction_provider) { ActiveRecord::Base }

  describe ".transaction_provider" do
    subject { example_class.__send__(:transaction_provider) }

    it { is_expected.to eq transaction_provider }
  end

  describe ".wrap_in_transaction" do
    subject(:wrap_in_transaction) { example_class.__send__(:wrap_in_transaction, **options) }

    let(:options) do
      {}
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
          let(:test_value) { described_class::CALLBACKS_FOR_TRANSACTIONS.sample }
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
          let(:expected_wrapped_methods) { described_class::CALLBACKS_FOR_TRANSACTIONS.without(test_value) }
          let(:listing_type) { :except }
          let(:test_value) { described_class::CALLBACKS_FOR_TRANSACTIONS.sample }
        end
      end
    end
  end
end
