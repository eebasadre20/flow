# frozen_string_literal: true

RSpec.shared_examples_for "methods are wrapped in a transaction" do
  before do
    allow(example_class).to receive(:set_callback).and_call_original
    wrap_in_transaction
  end

  let(:expected_no_wrapped_methods) { methods_to_transaction_wrap - expected_wrapped_methods }

  it "wraps expected methods" do
    expected_no_wrapped_methods.each do |method_name|
      expect(example_class).not_to have_received(:set_callback).with(method_name, :around)
    end

    expected_wrapped_methods.each do |method_name|
      expect(example_class).to have_received(:set_callback).with(method_name, :around, instance_of(Proc))
    end
  end
end
