# frozen_string_literal: true

# RSpec matcher for flow state arguments.
#
# Usage:
#
# RSpec.describe ExampleState, type: :state do
#   subject { described_class.new(**input) }
#
#   let(:input) { {} }
#
#   it { is_expected.to have_argument :foo }
# end

RSpec::Matchers.define :have_argument do |argument|
  match { |instance| expect(instance._arguments).to include argument }
  description { "has argument #{argument}" }
  failure_message { |instance| "expected #{instance.class.name}# to have argument #{argument}" }
end
