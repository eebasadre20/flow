# frozen_string_literal: true

# State callbacks provide an extensible mechanism for composing functionality for a state object.
module State
  module Callbacks
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Callbacks
      define_callbacks :initialize
    end
  end
end
