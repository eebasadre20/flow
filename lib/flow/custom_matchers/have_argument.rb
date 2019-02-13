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
  match { expect(described_class._arguments).to include argument }
  description { "has argument #{argument}" }
  failure_message { "expected #{described_class.name}# to have argument #{argument}" }
end
