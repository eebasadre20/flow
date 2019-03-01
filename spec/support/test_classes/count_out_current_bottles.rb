# frozen_string_literal: true

class CountOutCurrentBottles < OperationBase
  def behavior
    state.output.push "#{state.bottles} on the wall#{", #{state.bottles}" if state.output.empty?}."
  end
end
