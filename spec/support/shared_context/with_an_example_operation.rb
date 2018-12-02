# frozen_string_literal: true

RSpec.shared_context "with an example operation" do
  subject(:example_operation) { example_operation_class.new(state) }

  let(:example_operation_class) { Class.new.include described_class }
  let(:state) { double }
end
