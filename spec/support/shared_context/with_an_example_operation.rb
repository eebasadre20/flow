# frozen_string_literal: true

RSpec.shared_context "with an example operation" do |extra_operation_modules = nil|
  subject(:example_operation) { example_operation_class.new(state) }

  let(:root_operation_modules) do
    [ ShortCircuIt, Technologic, Flow::Operation::Callbacks, Flow::Operation::Core, Flow::Operation::Accessors ]
  end
  let(:operation_modules) { root_operation_modules + Array.wrap(extra_operation_modules) }

  let(:root_operation_class) { Class.new }
  let(:example_operation_class) do
    root_operation_class.tap do |operation_class|
      operation_modules.each { |operation_module| operation_class.include operation_module }
    end
  end

  let(:state_class) { Class.new(Flow::StateBase) }
  let(:state) { state_class.new }
end
