# frozen_string_literal: true

RSpec.shared_context "with operation callbacks" do |callback|
  include_context "with callbacks", callback

  let(:example_class) { example_operation_class }
end
