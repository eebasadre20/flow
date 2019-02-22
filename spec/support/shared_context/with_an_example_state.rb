# frozen_string_literal: true

RSpec.shared_context "with an example state" do |extra_state_modules = nil|
  subject(:example_state) { example_state_class.new(*input) }

  let(:root_state_modules) { [ Technologic, State::Callbacks, State::Core, State::Attributes ] }
  let(:state_modules) { root_state_modules + Array.wrap(extra_state_modules) }

  let(:root_state_class) { Class.new }
  let(:example_state_class) do
    root_state_class.tap do |state_class|
      state_modules.each { |state_module| state_class.include state_module }
    end
  end

  let(:input) { [] }
end
