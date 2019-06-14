# frozen_string_literal: true

require_relative "./bottle"
require_relative "./count_out_current_bottles"
require_relative "./pass_bottles_around"
require_relative "./take_bottles_down"
require_relative "./bottles_on_the_wall_state"

class BottlesOnTheWallFlow < Flow::FlowBase
  wrap_in_transaction

  operations CountOutCurrentBottles, TakeBottlesDown, PassBottlesAround, CountOutCurrentBottles
end
