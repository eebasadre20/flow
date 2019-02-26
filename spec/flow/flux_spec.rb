# frozen_string_literal: true

RSpec.describe Flow::Flux, type: :module do
  include_context "with example flow having state", [ Flow::Operations, described_class ]

  describe "#executed_operations" do
    subject { example_flow.__send__(:executed_operations) }

    it { is_expected.to eq [] }
  end

  describe "#failed_operation" do
    subject { example_flow.failed_operation }

    it { is_expected.to eq nil }
  end

  describe "#failed_operation?" do
    subject { example_flow.failed_operation? }

    context "without a #failed_operation" do
      it { is_expected.to eq false }
    end

    context "with a #failed_operation" do
      let(:failed_operation) { instance_double(OperationBase) }

      before { allow(example_flow).to receive(:failed_operation).and_return(failed_operation) }

      it { is_expected.to eq true }
    end
  end

  describe "#flux" do
    subject(:flux) { example_flow.flux }

    context "when successful" do
      before { allow(example_flow).to receive(:flux!) }

      it "calls flux!" do
        flux
        expect(example_flow).to have_received(:flux!)
      end
    end

    shared_examples_for "the error is logged and the flow reverted" do |example_error|
      let(:expected_state) { instance_of(example_state_class) }
      let(:expected_exception) { instance_of(example_error) }

      before do
        allow(example_flow).to receive(:flux!).and_raise example_error
        allow(example_flow).to receive(:error).and_call_original
        allow(example_flow).to receive(:revert)
      end

      it "calls revert" do
        flux
        expect(example_flow).to have_received(:revert)
      end

      it "logs the exception" do
        flux
        expect(example_flow).
          to have_received(:error).
          with(:error_executing_operation, state: expected_state, exception: expected_exception)
      end
    end

    context "when an error is raised" do
      it_behaves_like "the error is logged and the flow reverted", Class.new(StandardError)
    end

    context "when a failure occurs" do
      it_behaves_like "the error is logged and the flow reverted", Flow::Flux::Failure
    end
  end

  describe "#flux!" do
    subject(:flux!) { example_flow.flux! }

    it_behaves_like "a class with callback" do
      include_context "with flow callbacks", :flux

      subject(:callback_runner) { flux! }

      let(:example) { example_flow }
    end

    let(:operation0_class) { Class.new(OperationBase) }
    let(:operation1_class) { Class.new(OperationBase) }
    let(:operation2_class) { Class.new(OperationBase) }
    let(:operation0_name) { Faker::Internet.unique.domain_word.capitalize }
    let(:operation1_name) { Faker::Internet.unique.domain_word.capitalize }
    let(:operation2_name) { Faker::Internet.unique.domain_word.capitalize }
    let(:operations) { [ operation0_class, operation1_class, operation2_class ] }
    let(:state) { instance_double(example_state_class) }
    let(:operation_failure) { instance_double(Operation::Failures::OperationFailure) }
    let(:executed_operations) do
      operations.map { |operation| instance_of(operation) }
    end

    before do
      stub_const(operation0_name, operation0_class)
      stub_const(operation1_name, operation1_class)
      stub_const(operation2_name, operation2_class)

      example_flow_class._operations = operations.each do |operation|
        allow(operation).to receive(:execute).and_call_original
      end

      allow(example_flow).to receive(:state).and_return(state)
    end

    context "when nothing goes wrong" do
      it "executes all operations" do
        expect { flux! }.to change { example_flow.__send__(:executed_operations) }.from([]).to(executed_operations)
        expect(operations).to all(have_received(:execute).with(state).ordered)
      end
    end

    context "when an operation fails" do
      let(:operation1) { operation1_class.new(state) }

      before do
        allow(operation1_class).to receive(:execute).and_return(operation1)
        allow(operation1).to receive(:operation_failure).and_return(operation_failure)
      end

      it "raises, sets failed operation, and halts" do
        expect { flux! }.
          to raise_error(Flow::Flux::Failure).
          and change { example_flow.__send__(:failed_operation) }.from(nil).to(operation1).
          and change { example_flow.__send__(:executed_operations) }.from([]).to([ executed_operations.first ])
        expect(operation2_class).not_to have_received(:execute)
      end
    end

    context "when an operation raises" do
      let(:example_error) { Class.new(StandardError) }

      before { allow(operation1_class).to receive(:execute).and_raise example_error }

      it "raises" do
        expect { flux! }.
          to raise_error(example_error).
          and change { example_flow.__send__(:executed_operations) }.from([]).to([ executed_operations.first ])
        expect(operation2_class).not_to have_received(:execute)
        expect(example_flow).not_to be_failed_operation
      end
    end
  end
end
