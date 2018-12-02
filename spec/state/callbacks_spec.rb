# frozen_string_literal: true

RSpec.describe State::Callbacks, type: :module do
  describe "callbacks" do
    subject(:example_class) do
      Class.new do
        include State::Callbacks
      end
    end

    it { is_expected.to include_module ActiveSupport::Callbacks }

    describe "definitions" do
      subject { example_class.__callbacks }

      it { is_expected.to include :initialize }
    end
  end
end
