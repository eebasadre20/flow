# frozen_string_literal: true

RSpec.describe Flow::Malfunction, type: :malfunction do
  it { is_expected.to inherit_from Malfunction::MalfunctionBase }
end
