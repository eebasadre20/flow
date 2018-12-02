# frozen_string_literal: true

RSpec.describe State::Options, type: :module do
  describe ".option" do
    subject(:define_option) { example_class.__send__(:option, option) }

    let(:option) { Faker::Lorem.word.to_sym }
    let(:example_class) do
      Class.new do
        include State::Callbacks
        include State::Attributes
        include State::Options
      end
    end

    before { allow(example_class).to receive(:define_attribute).and_call_original }

    describe "defines option" do
      let(:default) { Faker::Lorem.word }
      let(:instance) { instance_double(State::Options::Option) }
      let(:expected_options) { Hash[option, instance] }

      shared_examples_for "an option is defined" do
        it "adds to _options" do
          expect { define_option }.to change { example_class._options }.from({}).to(expected_options)
        end
      end

      context "when no block is given" do
        subject(:define_option) { example_class.__send__(:option, option, default: default) }

        before { allow(State::Options::Option).to receive(:new).with(default: default).and_return(instance) }

        it_behaves_like "an option is defined"
      end

      context "when a block is given" do
        subject(:define_option) { example_class.__send__(:option, option, default: default, &block) }

        let(:block) do
          ->(_) { :block }
        end

        before { allow(State::Options::Option).to receive(:new).with(default: default, &block).and_return(instance) }

        it_behaves_like "an option is defined"
      end
    end

    it "defines an attribute" do
      define_option
      expect(example_class).to have_received(:define_attribute).with(option)
    end
  end

  describe ".inherited" do
    let(:base_class) do
      Class.new do
        include State::Callbacks
        include State::Attributes
        include State::Options

        option :base
      end
    end

    let(:parentA_class) do
      Class.new(base_class) do
        option :parentA
      end
    end

    let(:parentB_class) do
      Class.new(base_class) do
        option :parentB
      end
    end

    let!(:childA1_class) do
      Class.new(parentA_class) do
        option :childA1
      end
    end

    let!(:childA2_class) do
      Class.new(parentA_class) do
        option :childA2
      end
    end

    let!(:childB_class) do
      Class.new(parentB_class) do
        option :childB
      end
    end

    shared_examples_for "an object with inherited options" do
      let(:expected_options_hash) do
        expected_options.each_with_object({}) { |option, hash| hash[option] = instance_of(State::Options::Option) }
      end

      it "has expected _options" do
        expect(example_class._options).to match expected_options_hash
      end
    end

    describe "#base_class" do
      subject(:example_class) { base_class }

      let(:expected_options) { %i[base] }

      include_examples "an object with inherited options"
    end

    describe "#parentA" do
      subject(:example_class) { parentA_class }

      let(:expected_options) { %i[base parentA] }

      include_examples "an object with inherited options"
    end

    describe "#parentB" do
      subject(:example_class) { parentB_class }

      let(:expected_options) { %i[base parentB] }

      include_examples "an object with inherited options"
    end

    describe "#childA1" do
      subject(:example_class) { childA1_class }

      let(:expected_options) { %i[base parentA childA1] }

      include_examples "an object with inherited options"
    end

    describe "#childA2" do
      subject(:example_class) { childA2_class }

      let(:expected_options) { %i[base parentA childA2] }

      include_examples "an object with inherited options"
    end

    describe "#childB" do
      subject(:example_class) { childB_class }

      let(:expected_options) { %i[base parentB childB] }

      include_examples "an object with inherited options"
    end
  end

  describe ".after_initialize" do
    subject(:instance) { example_class.new(**options) }

    let(:example_class) do
      Class.new do
        include State::Callbacks
        include State::Attributes
        include State::Core
        include State::Options

        option :test_option1, default: :default_value1
        option(:test_option2) { :default_value2 }
      end
    end

    context "when all options are provided" do
      let(:options) do
        { test_option1: :test_value1, test_option2: :test_value2 }
      end

      it "uses provided data" do
        options.each { |key, value| expect(instance.public_send(key)).to eq value }
      end
    end

    context "when one option is omitted" do
      let(:options) do
        { test_option1: :test_value1 }
      end

      it "uses provided and default data" do
        expect(instance.test_option1).to eq options[:test_option1]
        expect(instance.test_option2).to eq :default_value2
      end
    end

    context "when all options are omitted" do
      let(:options) do
        {}
      end

      it "uses default data" do
        expect(instance.test_option1).to eq :default_value1
        expect(instance.test_option2).to eq :default_value2
      end
    end
  end
end
