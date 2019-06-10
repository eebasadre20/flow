# frozen_string_literal: true

# Stubs a given flow to always fail when triggered.
#
# Requires let variables to be defined in the inclusion context:
# * failing_flow_class
#
# Defines the following variable:
# * failure_problem
RSpec.shared_context "with stubbed operation failure" do
  let(:failure_problem) { Faker::Lorem.words.join("-").parameterize.underscore }
  let(:failing_operation) do
    Class.new(Flow::OperationBase).tap do |klass|
      klass.instance_exec(self) do |spec_context|
        failure spec_context.failure_problem

        define_method :behavior do
          instance_eval("#{spec_context.failure_problem}_failure!")
        end
      end
    end
  end

  before do
    stub_const("FailingOperation", failing_operation)

    failing_flow_class._operations.unshift failing_operation
  end

  after do
    failing_flow_class._operations.shift
  end
end
