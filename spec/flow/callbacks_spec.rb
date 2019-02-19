# frozen_string_literal: true

RSpec.describe Flow::Callbacks, type: :module do
  describe "callbacks" do
    subject(:example_class) do
      Class.new do
        include Flow::Callbacks
      end
    end

    it { is_expected.to include_module ActiveSupport::Callbacks }

    describe "definitions" do
      subject { example_class.__callbacks }

      it { is_expected.to include :initialize }
    end
  end
end
