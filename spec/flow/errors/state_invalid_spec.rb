# frozen_string_literal: true

RSpec.describe Flow::Flow::Errors::StateInvalid, type: :error do
  it { is_expected.to inherit_from StandardError }
end
