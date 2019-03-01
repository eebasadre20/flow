# frozen_string_literal: true

class Bottle < ActiveRecord::Base
  validates :of, uniqueness: true
  validates :number_on_the_wall,
            :number_passed_around,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :number_passed_around, numericality: { less_than_or_equal_to: 100 }

  def to_s
    return "No more bottles of #{of}" if number_on_the_wall == 0

    "#{number_on_the_wall} #{"bottle".pluralize(number_on_the_wall)} of #{of}"
  end
end
