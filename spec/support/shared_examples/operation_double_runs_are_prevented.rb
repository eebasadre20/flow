# frozen_string_literal: true

RSpec.shared_examples_for "operation double runs are prevented" do |public_method, internal_method, error_class|
  subject(:call_method) { example_operation.public_send(public_method) }

  before do
    allow(example_operation).to receive(internal_method).and_call_original
    example_operation.public_send(public_method)
  end

  it "raises" do
    expect { call_method }.to raise_error error_class
    expect(example_operation).to have_received(internal_method).once
  end
end
