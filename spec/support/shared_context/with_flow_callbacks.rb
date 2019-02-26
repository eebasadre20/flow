# frozen_string_literal: true

RSpec.shared_context "with flow callbacks" do |callback|
  include_context "with callbacks", callback

  let(:example_class) { example_flow_class }
end
