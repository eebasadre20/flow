# frozen_string_literal: true

RSpec.describe Operation::Execute, type: :module do
  include_context "with an example operation", Operation::Execute

  describe ".execute!" do
    it_behaves_like "a class pass method", :execute! do
      let(:test_class) { example_operation_class }
    end
  end

  describe ".execute" do
    it_behaves_like "a class pass method", :execute do
      let(:test_class) { example_operation_class }
    end
  end

  describe "#execute!" do
    subject(:execute!) { example_operation.execute! }

    before do
      allow(example_operation).to receive(:surveil).and_call_original
      allow(example_operation).to receive(:behavior)

      example_operation_class.attr_accessor :before_hook_run, :around_hook_run, :after_hook_run
      example_operation_class.set_callback(:execute, :before) { |obj| obj.before_hook_run = true }
      example_operation_class.set_callback(:execute, :after) { |obj| obj.after_hook_run = true }
      example_operation_class.set_callback :execute, :around do |obj, block|
        obj.around_hook_run = true
        block.call
      end
    end

    it_behaves_like "a class with callback" do
      subject(:callback_runner) { execute! }

      let(:example) { example_operation }
    end

    it "calls #behavior" do
      execute!
      expect(example_operation).to have_received(:behavior).with(no_args)
    end

    it "is surveiled" do
      execute!
      expect(example_operation).to have_received(:surveil).with(:execute)
    end
  end

  describe "#execute" do
    subject(:execute) { example_operation.execute }

    context "when nothing goes wrong" do
      let(:execute_response) { double }

      before { allow(example_operation).to receive(:execute!).and_return(execute_response) }

      it { is_expected.to eq execute_response }
    end

    context "when a failure occurs" do
      before { allow(example_operation).to receive(:execute!).and_raise(Operation::Failures::OperationFailure) }

      it { is_expected.to eq false }

      it "tracks the failure" do
        expect { execute }.
          to change { example_operation.__send__(:operation_failure) }.
          from(nil).
          to(instance_of(Operation::Failures::OperationFailure))
      end
    end

    context "when an unexpected error occurs" do
      before { allow(example_operation).to receive(:execute!).and_raise(StandardError) }

      it "raises" do
        expect { execute }.to raise_error(StandardError)
      end
    end
  end

  describe "#behavior" do
    subject(:behavior) { example_operation.behavior }

    it { is_expected.to eq nil }
  end
end
