# frozen_string_literal: true

class BottlesOnTheWallFlow < FlowBase
  wrap_in_transaction only: :revert

  operations CountOutCurrentBottles, TakeBottlesDown, PassBottlesAround, CountOutCurrentBottles
end
