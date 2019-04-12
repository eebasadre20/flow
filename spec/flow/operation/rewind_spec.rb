# frozen_string_literal: true

RSpec.describe Flow::Operation::Rewind, type: :module do
  subject(:example_class) { Class.new.include described_class }

  include_context "with an example operation", [ described_class, Flow::Operation::Status ]

  describe "#rewind" do
    subject(:rewind) { example_operation.rewind }

    before do
      allow(example_operation).to receive(:surveil).and_call_original
      allow(example_operation).to receive(:undo)
    end

    it { is_expected.to eq example_operation }

    it_behaves_like "operation double runs are prevented", :rewind, :undo, Flow::Operation::Errors::AlreadyRewound

    it_behaves_like "a class with callback" do
      include_context "with operation callbacks", :rewind

      subject(:callback_runner) { rewind }

      let(:example) { example_operation }
    end

    it_behaves_like "a class with callback" do
      include_context "with operation callbacks", :undo

      subject(:callback_runner) { rewind }

      let(:example) { example_operation }
    end

    it "calls #undo" do
      rewind
      expect(example_operation).to have_received(:undo).with(no_args)
    end

    it "is surveiled" do
      rewind
      expect(example_operation).to have_received(:surveil).with(:rewind)
    end
  end

  describe "#undo" do
    subject(:undo) { example_operation.undo }

    it { is_expected.to eq nil }
  end
end
