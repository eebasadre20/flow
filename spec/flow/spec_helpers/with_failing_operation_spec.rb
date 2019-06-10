# frozen_string_literal: true

require_relative "../../support/test_classes/bottles_on_the_wall_flow"

RSpec.describe "with failing operation" do
  subject(:flow) { failing_flow_class.new(bottles_of: :test_fluid) }

  let(:failing_flow_class) { BottlesOnTheWallFlow }

  include_context "with failing operation"

  before { flow.trigger }

  it "fails the flow" do
    expect(flow).to be_failed
    expect(flow.failed_operation).to be_a FailingOperation
    expect(flow.failed_operation.operation_failure.problem).to eq failure_problem.to_sym
  end
end
