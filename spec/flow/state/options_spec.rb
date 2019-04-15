# frozen_string_literal: true

RSpec.describe Flow::State::Options, type: :module do
  include_context "with an example state", [ Flow::State::Defaults, described_class ]

  describe ".option" do
    it_behaves_like "a class which defines into a class collection", :option, :_options
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :option do
      let(:root_class) { example_state_class }
    end
  end

  describe ".after_initialize" do
    subject(:instance) { example_class.new(**key_values) }

    let(:example_class) do
      Class.new do
        include Flow::State::Callbacks
        include Flow::State::Defaults
        include Flow::State::Attributes
        include Flow::State::Core
        include Flow::State::Options

        option :test_option1, default: :default_value1
        option(:test_option2) { :default_value2 }
      end
    end

    it_behaves_like "a class with attributes having default values"
  end
end
