# frozen_string_literal: true

RSpec.describe Flow::State::Errors::NotValidated, type: :error do
  it { is_expected.to inherit_from StandardError }
end
