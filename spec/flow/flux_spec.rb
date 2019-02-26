# frozen_string_literal: true

RSpec.describe Flow::Flux, type: :module do
  include_context "with example flow having state", [ Flow::Operations, described_class ]

  # TODO: executed_operations
  # TODO: failed_operation
  # TODO: flux
  # TODO: error logging
  # TODO: revert being called
end
