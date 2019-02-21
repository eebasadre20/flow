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
    let(:base_class) do
      Class.new(example_state_class) { argument :base }
    end

    let(:parentA_class) do
      Class.new(base_class) do
        argument :parentA
      end
    end

    let(:parentB_class) do
      Class.new(base_class) do
        argument :parentB
      end
    end

    let!(:childA1_class) do
      Class.new(parentA_class) do
        argument :childA1
      end
    end

    let!(:childA2_class) do
      Class.new(parentA_class) do
        argument :childA2
      end
    end

    let!(:childB_class) do
      Class.new(parentB_class) do
        argument :childB
      end
    end

    shared_examples_for "an object with inherited arguments" do
      it "has expected _arguments" do
        expect(example_class._arguments).to eq expected_arguments
      end
    end

    describe "#base_class" do
      subject(:example_class) { base_class }

      let(:expected_arguments) { %i[base] }

      include_examples "an object with inherited arguments"
    end

    describe "#parentA" do
      subject(:example_class) { parentA_class }

      let(:expected_arguments) { %i[base parentA] }

      include_examples "an object with inherited arguments"
    end

    describe "#parentB" do
      subject(:example_class) { parentB_class }

      let(:expected_arguments) { %i[base parentB] }

      include_examples "an object with inherited arguments"
    end

    describe "#childA1" do
      subject(:example_class) { childA1_class }

      let(:expected_arguments) { %i[base parentA childA1] }

      include_examples "an object with inherited arguments"
    end

    describe "#childA2" do
      subject(:example_class) { childA2_class }

      let(:expected_arguments) { %i[base parentA childA2] }

      include_examples "an object with inherited arguments"
    end

    describe "#childB" do
      subject(:example_class) { childB_class }

      let(:expected_arguments) { %i[base parentB childB] }

      include_examples "an object with inherited arguments"
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
