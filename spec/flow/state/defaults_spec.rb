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
end
