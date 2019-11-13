# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationOperation, type: :operation do
  subject { described_class }

  it { is_expected.to inherit_from Flow::OperationBase }
end
