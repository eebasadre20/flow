# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationOperation, type: :operation do
  subject { described_class.new(state) }

  let(:state) { double }

  it { is_expected.to inherit_from OperationBase }
end
