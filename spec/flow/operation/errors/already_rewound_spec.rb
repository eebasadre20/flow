# frozen_string_literal: true

RSpec.describe Flow::Operation::Errors::AlreadyRewound, type: :error do
  it { is_expected.to inherit_from StandardError }
end
