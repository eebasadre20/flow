# frozen_string_literal: true

RSpec.describe State::Attributes, type: :module do
  describe ".define_attribute" do
    subject(:define_attribute) { example_class.__send__(:define_attribute, attribute) }

    let(:attribute) { Faker::Lorem.word.to_sym }
    let(:example_class) do
      Class.new do
        include State::Callbacks
        include State::Attributes
      end
    end

    before { allow(example_class).to receive(:define_attribute_methods) }

    it "adds to _attributes" do
      expect { define_attribute }.to change { example_class._attributes }.from([]).to([ attribute ])
      expect(example_class).to have_received(:define_attribute_methods).with(attribute)
    end

    describe "accessors" do
      subject { example_class }

      before { define_attribute }

      it { is_expected.to be_public_method_defined attribute }
      it { is_expected.to be_public_method_defined "#{attribute}=" }
    end
  end

  describe ".inherited" do
    let(:base_class) do
      Class.new do
        include State::Callbacks
        include State::Attributes

        define_attribute :base
      end
    end

    let(:parentA_class) do
      Class.new(base_class) do
        define_attribute :parentA
      end
    end

    let(:parentB_class) do
      Class.new(base_class) do
        define_attribute :parentB
      end
    end

    let!(:childA1_class) do
      Class.new(parentA_class) do
        define_attribute :childA1
      end
    end

    let!(:childA2_class) do
      Class.new(parentA_class) do
        define_attribute :childA2
      end
    end

    let!(:childB_class) do
      Class.new(parentB_class) do
        define_attribute :childB
      end
    end

    shared_examples_for "an object with inherited arguments" do
      it "has expected _arguments" do
        expect(example_class._attributes).to eq expected_attributes
      end
    end

    describe "#base_class" do
      subject(:example_class) { base_class }

      let(:expected_attributes) { %i[base] }

      include_examples "an object with inherited arguments"
    end

    describe "#parentA" do
      subject(:example_class) { parentA_class }

      let(:expected_attributes) { %i[base parentA] }

      include_examples "an object with inherited arguments"
    end

    describe "#parentB" do
      subject(:example_class) { parentB_class }

      let(:expected_attributes) { %i[base parentB] }

      include_examples "an object with inherited arguments"
    end

    describe "#childA1" do
      subject(:example_class) { childA1_class }

      let(:expected_attributes) { %i[base parentA childA1] }

      include_examples "an object with inherited arguments"
    end

    describe "#childA2" do
      subject(:example_class) { childA2_class }

      let(:expected_attributes) { %i[base parentA childA2] }

      include_examples "an object with inherited arguments"
    end

    describe "#childB" do
      subject(:example_class) { childB_class }

      let(:expected_attributes) { %i[base parentB childB] }

      include_examples "an object with inherited arguments"
    end
  end
end
