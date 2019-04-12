# frozen_string_literal: true

# RSpec matcher that tests usage of `ApplicationState.argument`
#
#     class ExampleState < ApplicationState
#       argument :foo
#     end
#
#     RSpec.describe ExampleState, type: :state do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to define_argument :foo }
#     end

RSpec::Matchers.define :define_argument do |argument|
  match { |state| expect(state._arguments).to include argument }
  description { "define argument #{argument}" }
  failure_message { |state| "expected #{state.class.name} to define argument #{argument}" }
end
