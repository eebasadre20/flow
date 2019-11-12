# frozen_string_literal: true

RSpec.describe Flow::Operation::Core, type: :module do
  include_context "with an example operation"

  describe "#initialize" do
    subject(:operation) { example_operation }

    it "has state proxy" do
      expect(operation.state).to be_an_instance_of Flow::StateProxy
      expect(operation.state.__send__(:state)).to eq state
    end
  end
end
