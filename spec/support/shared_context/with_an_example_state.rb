# frozen_string_literal: true

RSpec.shared_context "with an example state" do |state_modules = nil|
  subject(:example_state) { example_state_class.new(*input) }

  let(:root_state_class) { Class.new(Spicerack::InputModel) }
  let(:example_state_class) do
    root_state_class.tap do |state_class|
      Array.wrap(state_modules).each { |state_module| state_class.include state_module }
    end
  end

  let(:example_name) { Faker::Internet.domain_word.capitalize }
  let(:example_state_name) { "#{example_name}State" }

  let(:input) { [] }

  before { stub_const(example_state_name, example_state_class) }
end
