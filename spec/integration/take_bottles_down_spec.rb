# frozen_string_literal: true

require_relative "../support/test_classes/take_bottles_down"

RSpec.describe TakeBottlesDown, type: :operation do
  subject { described_class.new(double) }

  it { is_expected.to wrap_in_transaction(except: :undo) }
  it { is_expected.to define_failure :too_greedy }
end
