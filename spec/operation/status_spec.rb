# frozen_string_literal: true

RSpec.describe Operation::Status, type: :module do
  include_context "with an example operation", [ Operation::Execute, Operation::Status ]

  describe "#executed?" do
    subject(:executed?) { example_operation.executed? }

    it { is_expected.to be false }

    context "when execute callbacks run" do
      subject(:run_execute_callback) { example_operation.run_callbacks(:execute) }

      it "changes" do
        expect { run_execute_callback }.to change { example_operation.executed? }.from(false).to(true)
      end
    end
  end

  describe "#failed?" do
    subject(:failed?) { example_operation.failed? }

    it { is_expected.to be false }

    context "when there is an operation failure" do
      before { example_operation.instance_variable_set(:@operation_failure, Operation::Failures::OperationFailure.new) }

      it { is_expected.to eq true }
    end
  end

  describe "#success?" do
    subject(:success?) { example_operation.success? }

    it { is_expected.to be false }

    context "when executed?" do
      before do
        allow(example_operation).to receive(:executed?).and_return(true)
        allow(example_operation).to receive(:failed?).and_return(failed?)
      end

      context "when NOT failure?" do
        let(:failed?) { false }

        it { is_expected.to be true }
      end

      context "when failure?" do
        let(:failed?) { true }

        it { is_expected.to be false }
      end
    end
  end
end
