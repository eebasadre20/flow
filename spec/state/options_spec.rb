# frozen_string_literal: true

RSpec.describe State::Options, type: :module do
  include_context "with an example state", State::Options

  describe ".option" do
    subject(:define_option) { example_state_class.__send__(:option, option) }

    let(:option) { Faker::Lorem.word.to_sym }

    before { allow(example_state_class).to receive(:define_attribute).and_call_original }

    describe "defines option" do
      let(:default) { Faker::Lorem.word }
      let(:instance) { instance_double(State::Options::Option) }
      let(:expected_options) { Hash[option, instance] }

      shared_examples_for "an option is defined" do
        it "adds to _options" do
          expect { define_option }.to change { example_state_class._options }.from({}).to(expected_options)
        end
      end

      context "when no block is given" do
        subject(:define_option) { example_state_class.__send__(:option, option, default: default) }

        before { allow(State::Options::Option).to receive(:new).with(default: default).and_return(instance) }

        it_behaves_like "an option is defined"
      end

      context "when a block is given" do
        subject(:define_option) { example_state_class.__send__(:option, option, default: default, &block) }

        let(:block) do
          ->(_) { :block }
        end

        before { allow(State::Options::Option).to receive(:new).with(default: default, &block).and_return(instance) }

        it_behaves_like "an option is defined"
      end
    end

    it "defines an attribute" do
      define_option
      expect(example_state_class).to have_received(:define_attribute).with(option)
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited array property", :option do
      let(:root_class) { example_state_class }
      let(:expected_attribute_value) do
        expected_property_value.each_with_object({}) do |option, hash|
          hash[option] = instance_of(State::Options::Option)
        end
      end
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
