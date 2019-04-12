# frozen_string_literal: true

require_relative "../support/test_classes/bottles_on_the_wall_flow"

RSpec.describe BottlesOnTheWallFlow, type: :flow do
  it { is_expected.to use_operations CountOutCurrentBottles, TakeBottlesDown, PassBottlesAround, CountOutCurrentBottles }
end
