# frozen_string_literal: true

RSpec.describe Operation::Transactions, type: :module do
  include_context "with an example operation", [
    TransactionWrapper,
    Operation::Execute,
    Operation::Rewind,
    Operation::Status,
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
