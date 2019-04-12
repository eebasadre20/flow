# frozen_string_literal: true

RSpec.describe Flow::Operation::Errors::AlreadyExecuted, type: :error do
  it { is_expected.to inherit_from StandardError }
end
