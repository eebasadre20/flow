# frozen_string_literal: true

RSpec.describe Flow::Status, type: :module do
  include_context "with example flow having state", [ Flow::Operations, Flow::Flux, Flow::Ebb, described_class ]

  describe "#pending?" do
    subject(:pending?) { example_flow.pending? }

    it { is_expected.to be true }

    context "with executed_operations" do
      before { example_flow.__send__(:executed_operations) << :operation }

      it { is_expected.to be false }
    end
  end

  describe "#triggered?" do
    subject(:triggered?) { example_flow.triggered? }

    it { is_expected.to be false }

    context "with executed_operations" do
      before { example_flow.__send__(:executed_operations) << :operation }

      it { is_expected.to be true }
    end
  end

  describe "#failed?" do
    subject(:failed?) { example_flow.failed? }

    before do
      allow(example_flow).to receive(:executed?).and_return(executed?)
      allow(example_flow).to receive(:success?).and_return(success?)
    end

    context "when neither executed? nor success?" do
      let(:executed?) { false }
      let(:success?) { false }

      it { is_expected.to be false }
    end

    context "when executed? but not success?" do
      let(:executed?) { true }
      let(:success?) { false }

      it { is_expected.to be true }
    end

    context "when executed? and success?" do
      let(:executed?) { true }
      let(:success?) { true }

      it { is_expected.to be false }
    end
  end

  describe "#success?" do
    subject(:success?) { example_flow.success? }

    it { is_expected.to be false }

    context "when operation_instances matches executed_operations" do
      before do
        example_flow.__send__(:operation_instances) << :operation
        example_flow.__send__(:executed_operations) << :operation
      end

      it { is_expected.to be true }
    end

    context "when operation_instances DOES NOT match executed_operations" do
      before do
        example_flow.__send__(:operation_instances) << :operation
        example_flow.__send__(:executed_operations) << :operation1
      end

      it { is_expected.to be false }
    end
  end

  describe "#reverted?" do
    subject(:reverted?) { example_flow.reverted? }

    it { is_expected.to be false }

    context "with rewound_operations" do
      before { example_flow.__send__(:rewound_operations) << :operation }

      it { is_expected.to be true }
    end
  end
end
