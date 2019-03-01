# frozen_string_literal: true

RSpec.describe Flow::Transactions, type: :module do
  include_context "with example flow having state", [
    TransactionWrapper,
    Flow::Operations,
    Flow::Flux,
    Flow::Ebb,
    described_class,
  ]

  it_behaves_like "a transaction wrapper" do
    let(:example_class) { example_flow_class }
    let(:example_instance) { example_flow }

    context "when #flux!" do
      it_behaves_like "method is wrapped in a transaction", :flux!, :flux, :_flux
    end

    context "when #ebb" do
      it_behaves_like "method is wrapped in a transaction", :ebb, :ebb, :_ebb
    end
  end
end
