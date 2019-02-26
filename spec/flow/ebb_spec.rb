# frozen_string_literal: true

RSpec.describe Flow::Ebb, type: :module do
  include_context "with example flow having state", [ Flow::Operations, described_class ]

  # TODO: reverted operations tracking
end
