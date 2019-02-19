# frozen_string_literal: true

RSpec.shared_examples_for "an example class with callbacks" do |callback_module, callbacks|
  subject(:example_class) { Class.new.include callback_module }

  it { is_expected.to include_module ActiveSupport::Callbacks }

  describe "__callbacks" do
    subject { example_class.__callbacks.keys }

    it { is_expected.to match_array Array.wrap(callbacks) }
  end
end
