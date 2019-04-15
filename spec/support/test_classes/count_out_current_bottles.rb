# frozen_string_literal: true

class CountOutCurrentBottles < Flow::OperationBase
  def behavior
    state.stanza.push "#{state.bottles} on the wall#{", #{state.bottles}" if state.stanza.empty?}."
  end
end
