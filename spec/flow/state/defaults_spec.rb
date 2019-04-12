# frozen_string_literal: true

RSpec.describe Flow::State::Defaults, type: :module do
  include_context "with an example state", Flow::State::Defaults

  describe ".define_default" do
    let(:attribute) { Faker::Lorem.word.to_sym }

    describe "defines default" do
      let(:static) { Faker::Lorem.word }
      let(:instance) { instance_double(Flow::State::Defaults::Value) }
      let(:expected_defaults) { Hash[attribute, instance] }

      shared_examples_for "a default is defined" do
        it "adds to _defaults" do
          expect { define_default }.to change { example_state_class._defaults }.from({}).to(expected_defaults)
        end
      end

      context "when no block is given" do
        subject(:define_default) { example_state_class.__send__(:define_default, attribute, static: static) }

        before { allow(Flow::State::Defaults::Value).to receive(:new).with(static: static).and_return(instance) }

        it_behaves_like "a default is defined"
      end

      context "when a block is given" do
        subject(:define_default) { example_state_class.__send__(:define_default, attribute, static: static, &block) }

        let(:block) do
          ->(_) { :block }
        end

        before do
          allow(Flow::State::Defaults::Value).to receive(:new).with(static: static, &block).and_return(instance)
        end

        it_behaves_like "a default is defined"
      end
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :define_default, :_defaults do
      let(:root_class) { example_state_class }
      let(:expected_attribute_value) do
        expected_property_value.each_with_object({}) do |option, hash|
          hash[option] = instance_of(Flow::State::Defaults::Value)
        end
      end
    end
  end

  describe ".after_initialize" do
    subject(:instance) { example_class.new }

    let(:example_class) do
      Class.new do
        include Flow::State::Callbacks
        include Flow::State::Defaults
        include Flow::State::Core

        attr_accessor :test_option1
        attr_accessor :test_option2

        define_default :test_option1, static: :default_value1
        define_default(:test_option2) { :default_value2 }
      end
    end

    before do
      key_values.each { |key, value| instance.public_send("#{key}=".to_sym, value) }
    end

    context "when all values are defined" do
      let(:key_values) do
        { test_option1: :test_value1, test_option2: :test_value2 }
      end

      it "uses provided data" do
        key_values.each { |key, value| expect(instance.public_send(key)).to eq value }
      end
    end

    context "when one value is omitted" do
      let(:key_values) do
        { test_option1: :test_value1 }
      end

      it "uses provided and default data" do
        expect(instance.test_option1).to eq key_values[:test_option1]
        expect(instance.test_option2).to eq :default_value2
      end
    end

    context "when all values are omitted" do
      let(:key_values) do
        {}
      end

      it "uses default data" do
        expect(instance.test_option1).to eq :default_value1
        expect(instance.test_option2).to eq :default_value2
      end
    end
  end
end
