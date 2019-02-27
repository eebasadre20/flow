# frozen_string_literal: true

RSpec.describe Flow::Flux::Failure, type: :error do
  it { is_expected.to inherit_from StandardError }
end
