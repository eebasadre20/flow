# frozen_string_literal: true

RSpec.describe Flow::Operation::Transactions, type: :module do
  include_context "with an example operation", [
    Flow::TransactionWrapper,
    Flow::Operation::Execute,
    Flow::Operation::Rewind,
    Flow::Operation::Status,
    described_class,
  ]

  it_behaves_like "a transaction wrapper" do
    let(:example_class) { example_operation_class }
    let(:example_instance) { example_operation }

    context "when #execute!" do
      it_behaves_like "method is wrapped in a transaction", :execute!, :behavior
    end

    context "when #rewind" do
      it_behaves_like "method is wrapped in a transaction", :rewind, :behavior
    end
  end
end
