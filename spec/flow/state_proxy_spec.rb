# frozen_string_literal: true

RSpec.describe Flow::StateProxy, type: :state_proxy do
  include_context "with an example state"

  subject(:state_proxy) { described_class.new(state) }

  let(:state) { example_state }

  describe "#state" do
    subject { state_proxy.__send__(:state) }

    it { is_expected.to eq example_state }
  end
end
