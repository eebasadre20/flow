# frozen_string_literal: true

RSpec.shared_examples_for "methods are wrapped in a transaction with a variety of input" do
  let(:methods_to_transaction_wrap) { example_class::callbacks_for_transaction }
  let(:expected_wrapped_methods) { example_class::callbacks_for_transaction }

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
