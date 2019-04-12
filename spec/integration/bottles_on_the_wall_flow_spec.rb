# frozen_string_literal: true

require_relative "../support/test_classes/count_out_current_bottles"
require_relative "../support/test_classes/pass_bottles_around"
require_relative "../support/test_classes/take_bottles_down"
require_relative "../support/test_classes/bottles_on_the_wall_flow"

RSpec.describe BottlesOnTheWallFlow, type: :flow do
  it { is_expected.to use_operations CountOutCurrentBottles, TakeBottlesDown, PassBottlesAround, CountOutCurrentBottles }
end
