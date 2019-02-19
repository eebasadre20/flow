# frozen_string_literal: true

RSpec.describe Flow::Errors::StateInvalid, type: :error do
  it { is_expected.to inherit_from StandardError }
end
