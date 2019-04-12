# frozen_string_literal: true

require_relative "../support/test_classes/pass_bottles_around"

RSpec.describe PassBottlesAround, type: :operation do
  subject { described_class.new(double) }

  it { is_expected.to wrap_in_transaction(only: :behavior) }
end
