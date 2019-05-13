# frozen_string_literal: true

RSpec.shared_context "with an example state" do |state_modules = nil|
  subject(:example_state) { example_state_class.new(*input) }

  let(:root_state_class) { Class.new(Instructor::Base) }
  let(:example_state_class) do
    root_state_class.tap do |state_class|
      Array.wrap(state_modules).each { |state_module| state_class.include state_module }
    end
  end

  let(:input) { [] }
end
