# frozen_string_literal: true

RSpec.describe Flow::Trigger, type: :module do
  include_context "with example flow having state", [ Flow::Operations, Flow::Flux, described_class ]

  it { is_expected.to delegate_method(:valid?).to(:state).with_prefix(true) }

  describe ".trigger!" do
    it_behaves_like "a class pass method", :trigger! do
      let(:test_class) { example_flow_class }
    end
  end

  describe ".trigger" do
    it_behaves_like "a class pass method", :trigger do
      let(:test_class) { example_flow_class }
    end
  end

  describe "#trigger!" do
    subject(:trigger!) { flow.trigger! }

    let(:flow) { example_flow_class.new }
    let(:state) { instance_double(example_state_class) }

    before do
      allow(flow).to receive(:state).and_return(state)
      allow(flow).to receive(:flux)
      allow(state).to receive(:valid?).and_return(state_valid?)
    end

    context "when the state is valid" do
      before { allow(flow).to receive(:surveil).and_call_original }

      let(:state_valid?) { true }

      it { is_expected.to eq state }

      it "is surveiled" do
        trigger!
        expect(flow).to have_received(:flux)
        expect(flow).to have_received(:surveil).with(:trigger)
      end
    end

    context "when the state is NOT valid" do
      let(:state_valid?) { false }

      it "does not executes operations" do
        expect { trigger! }.to raise_error Flow::Errors::StateInvalid
        expect(flow).not_to have_received(:flux)
      end
    end
  end

  describe "#trigger" do
    subject(:trigger) { flow.trigger }

    let(:flow) { example_flow_class.new }

    context "with valid state" do
      let(:state) { instance_double(example_state_class) }

      before { allow(flow).to receive(:trigger!).and_return(state) }

      it { is_expected.to eq state }
    end

    context "with invalid state" do
      before { allow(flow).to receive(:trigger!).and_raise(Flow::Errors::StateInvalid) }

      it { is_expected.to be_nil }
    end
  end
end
