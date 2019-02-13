# frozen_string_literal: true

RSpec.describe FlowBase::StateInvalid, type: :error do
  it { is_expected.to inherit_from StandardError }
end
