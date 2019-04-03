# frozen_string_literal: true

class BottlesOnTheWallFlow < FlowBase
  wrap_in_transaction only: :ebb

  operations CountOutCurrentBottles, TakeBottlesDown, PassBottlesAround, CountOutCurrentBottles
end
