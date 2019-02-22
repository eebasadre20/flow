# frozen_string_literal: true

RSpec.describe State::Arguments, type: :module do
  include_context "with an example state", State::Arguments

  describe ".argument" do
    subject(:define_argument) { example_state_class.__send__(:argument, argument) }

    let(:argument) { Faker::Lorem.word.to_sym }

    before { allow(example_state_class).to receive(:define_attribute).and_call_original }

    it "adds to _arguments" do
      expect { define_argument }.to change { example_state_class._arguments }.from([]).to([ argument ])
    end

    it "defines an attribute" do
      define_argument
      expect(example_state_class).to have_received(:define_attribute).with(argument)
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited array property", :argument do
      let(:root_class) { example_state_class }
    end
  end

  describe ".after_initialize" do
    subject(:init) { example_class.new(**arguments) }

    let(:example_class) do
      Class.new do
        include State::Callbacks
        include State::Attributes
        include State::Core

        include State::Arguments

        argument :test_argument1
        argument :test_argument2
      end
    end

    context "when arguments are provided" do
      let(:arguments) do
        { test_argument1: :test_value1, test_argument2: :test_value2 }
      end

      it "does not raise" do
        expect { init }.not_to raise_error
      end
    end

    context "when one argument is omitted" do
      let(:arguments) do
        { test_argument1: :test_value1 }
      end

      it "does not raise" do
        expect { init }.to raise_error ArgumentError, "Missing argument: test_argument2"
      end
    end

    context "when multiple arguments are omitted" do
      let(:arguments) do
        {}
      end

      it "does not raise" do
        expect { init }.to raise_error ArgumentError, "Missing arguments: test_argument1, test_argument2"
      end
    end
  end
end
