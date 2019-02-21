# frozen_string_literal: true

RSpec.describe Operation::Execute, type: :module do
  include_context "with an example operation", Operation::Execute

  describe ".execute" do
    it_behaves_like "a class pass method", :execute do
      let(:test_class) { example_operation_class }
    end
  end

  describe "#execute" do
    subject(:execute) { example_operation.execute }

    it "raises" do
      expect { execute }.to raise_error NotImplementedError
    end
  end
end
