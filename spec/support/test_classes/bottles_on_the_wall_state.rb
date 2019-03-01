# frozen_string_literal: true

class BottlesOnTheWallState < StateBase
  argument :bottles_of

  option :starting_bottles
  option :number_to_take_down, default: 1
  option :output, default: []

  validates :number_to_take_down, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def stanza
    output.join("\n")
  end

  def taking_down_one?
    number_to_take_down == 1
  end

  def bottles
    Bottle.find_or_create_by(of: bottles_of) do |bottles|
      bottles.number_on_the_wall = starting_bottles if starting_bottles
    end
  end
  memoize :bottles
end
