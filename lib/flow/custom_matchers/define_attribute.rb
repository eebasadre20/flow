# frozen_string_literal: true

# RSpec matcher for flow state attributes.
#
# Usage:
#
# RSpec.describe ExampleState, type: :state do
#   subject { described_class.new(**input) }
#
#   let(:input) { {} }
#
#   it { is_expected.to define_attribute :foo }
# end

RSpec::Matchers.define :define_attribute do |attribute|
  match { |state| expect(state.class._attributes).to include attribute }
  description { "has attribute #{attribute}" }
  failure_message { |state| "expected #{state.class.name}# to have attribute #{attribute}" }
end
