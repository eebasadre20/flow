# frozen_string_literal: true

RSpec.shared_context "with example flow having state" do |extra_flow_modules = nil|
  subject(:example_flow) { example_flow_class.new }

  let(:root_flow_modules) { [ ShortCircuIt, Technologic, Flow::Flow::Callbacks, Flow::Flow::Core ] }
  let(:flow_modules) { root_flow_modules + Array.wrap(extra_flow_modules) }

  let(:root_flow_class) { Class.new }
  let(:example_flow_class) do
    root_flow_class.tap do |flow_class|
      flow_modules.each { |flow_module| flow_class.include flow_module }
    end
  end

  let(:example_root_name) { Faker::Internet.domain_word.capitalize }
  let(:example_flow_name) { "#{example_root_name}Flow" }
  let(:example_state_name) { "#{example_root_name}State" }
  let(:example_state_class) { Class.new(Flow::StateBase) }

  before do
    stub_const(example_flow_name, example_flow_class)
    stub_const(example_state_name, example_state_class)
  end
end
