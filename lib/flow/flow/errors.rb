# frozen_string_literal: true

# Errors specific to Flows.
module Flow
  module Errors
    extend ActiveSupport::Concern

    included do
      class StateInvalid < StandardError; end
    end
  end
end
