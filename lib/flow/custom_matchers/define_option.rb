# frozen_string_literal: true

# RSpec matcher for flow state options.
#
# Usage:
#
# RSpec.describe ExampleState, type: :state do
#   subject { described_class.new(**input) }
#
#   let(:input) { {} }
#
#   it { is_expected.to define_option :foo }
#   it { is_expected.to define_option :foo, default_value }
# end

RSpec::Matchers.define :define_option do |option, default_value = nil|
  match { |state| expect(state._options[option].default_value).to eq default_value }
  description { "has option #{option}" }
  failure_message { |state| "expected #{state.class.name}# to have option #{option}, #{for_default(default_value)}" }

  def for_default(default_value)
    return "without a default value" if default_value.nil?

    "with default value #{default_value}"
  end
end
