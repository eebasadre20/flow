# frozen_string_literal: true

# Stubs a given flow to always fail when triggered.
# Requires the following let variables to be defined in the incnlusion context:
# * failing_flow_class
# * failure_name
RSpec.shared_context "with stubbed operation failure" do
  let(:failing_operation) do
    Class.new(Flow::OperationBase).instance_exec(failure_name) do |failure_name|
      failure failure_name

      def behavior
        __send__("#{failure_name}_failure!")
      end
    end
  end

  before do
    stub_const("FailingOperation", failing_operation)
    failing_flow_class._operations << failing_operation
  end
end
