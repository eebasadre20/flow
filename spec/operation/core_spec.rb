# frozen_string_literal: true

RSpec.describe Operation::Core, type: :module do
  include_context "with an example operation"

  describe "#initialize" do
    subject { example_operation.state }

    it { is_expected.to eq state }
  end
end
