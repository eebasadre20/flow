# frozen_string_literal: true

RSpec.describe Flow::Trigger, type: :module do
  include_context "with example flow having state", [ Flow::Operations, described_class ]

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
    let(:operation0) { Class.new(OperationBase) }
    let(:operation1) { Class.new(OperationBase) }
    let(:operation2) { Class.new(OperationBase) }
    let(:operation0_name) { Faker::Internet.unique.domain_word.capitalize }
    let(:operation1_name) { Faker::Internet.unique.domain_word.capitalize }
    let(:operation2_name) { Faker::Internet.unique.domain_word.capitalize }
    let(:operations) { [ operation0, operation1, operation2 ] }
    let(:state) { instance_double(example_state_class) }

    before do
      stub_const(operation0_name, operation0)
      stub_const(operation1_name, operation1)
      stub_const(operation2_name, operation2)

      example_flow_class._operations = operations.each { |operation| allow(operation).to receive(:execute) }
      allow(flow).to receive(:state).and_return(state)
      allow(state).to receive(:valid?).and_return(state_valid?)
    end

    context "when the state is valid" do
      before { allow(flow).to receive(:surveil).and_call_original }

      let(:state_valid?) { true }

      it { is_expected.to eq state }

      it "executes surveiled operations" do
        trigger!
        expect(operations).to all(have_received(:execute).with(state).ordered)
        expect(flow).to have_received(:surveil).with(:trigger)
        operations.each { |operation| expect(flow).to have_received(:surveil).with(operation.name) }
      end
    end

    context "when the state is NOT valid" do
      let(:state_valid?) { false }

      it "does not executes operations" do
        expect { trigger! }.to raise_error Flow::Errors::StateInvalid
        operations.each { |operation| expect(operation).not_to have_received(:execute) }
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
