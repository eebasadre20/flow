# frozen_string_literal: true

RSpec.describe Operation::Errors::AlreadyExecuted, type: :error do
  it { is_expected.to inherit_from StandardError }
end
