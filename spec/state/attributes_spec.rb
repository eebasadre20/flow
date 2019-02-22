# frozen_string_literal: true

RSpec.describe State::Attributes, type: :module do
  include_context "with an example state", State::Options

  describe ".define_attribute" do
    subject(:define_attribute) { example_state_class.__send__(:define_attribute, attribute) }

    let(:attribute) { Faker::Lorem.word.to_sym }

    before { allow(example_state_class).to receive(:define_attribute_methods) }

    it "adds to _attributes" do
      expect { define_attribute }.to change { example_state_class._attributes }.from([]).to([ attribute ])
      expect(example_state_class).to have_received(:define_attribute_methods).with(attribute)
    end

    describe "accessors" do
      subject { example_state_class }

      before { define_attribute }

      it { is_expected.to be_public_method_defined attribute }
      it { is_expected.to be_public_method_defined "#{attribute}=" }
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited array property", :define_attribute, :_attributes do
      let(:root_class) { example_state_class }
    end
  end
end
