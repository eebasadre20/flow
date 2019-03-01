# frozen_string_literal: true

RSpec.describe Flow::Revert, type: :module do
  include_context "with example flow having state", [ Flow::Operations, Flow::Ebb, described_class ]

  describe "#revert" do
    subject(:revert) { flow.revert }

    let(:flow) { example_flow_class.new }
    let(:state) { instance_double(example_state_class) }

    before { allow(flow).to receive(:state).and_return(state) }

    context "with no problems" do
      before do
        allow(flow).to receive(:ebb)
        allow(flow).to receive(:surveil).and_call_original
      end

      let(:state_valid?) { true }

      it { is_expected.to eq state }

      it "is surveiled" do
        revert
        expect(flow).to have_received(:ebb)
        expect(flow).to have_received(:surveil).with(:revert)
      end
    end

    context "with a problem" do
      let(:example_error) { Class.new(StandardError) }

      before { allow(flow).to receive(:ebb).and_raise example_error }

      it "is surveiled" do
        expect { revert }.to raise_error example_error
      end
    end
  end
end
