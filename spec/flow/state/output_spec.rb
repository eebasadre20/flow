# frozen_string_literal: true

RSpec.describe Flow::State::Output, type: :module do
  include_context "with an example state", [
    ActiveModel,
    ActiveModel::Validations::Callbacks,
    Flow::State::Defaults,
    described_class,
  ]

  describe ".output" do
    subject(:define_output) { example_state_class.__send__(:output, output) }

    let(:output) { Faker::Lorem.word.to_sym }

    before do
      allow(example_state_class).to receive(:define_default).and_call_original
      allow(example_state_class).to receive(:define_attribute).and_call_original
    end

    describe "defines output" do
      let(:default) { Faker::Lorem.word }

      shared_examples_for "an output is defined" do
        it "adds to _outputs" do
          expect { define_output }.to change { example_state_class._outputs }.from([]).to([ output ])
        end
      end

      context "when no block is given" do
        subject(:define_output) { example_state_class.__send__(:output, output, default: default) }

        it_behaves_like "an output is defined"

        it "defines an static default" do
          define_output
          expect(example_state_class).to have_received(:define_default).with(output, static: default)
        end
      end

      context "when a block is given" do
        subject(:define_output) { example_state_class.__send__(:output, output, default: default, &block) }

        let(:block) do
          ->(_) { :block }
        end

        shared_examples_for "values are handed off to define_default" do
          it "calls define_default" do
            define_output
            expect(example_state_class).to have_received(:define_default).with(output, static: default, &block)
          end
        end

        context "with a static default" do
          it_behaves_like "values are handed off to define_default"
        end

        context "without a static default" do
          let(:default) { nil }

          it_behaves_like "values are handed off to define_default"
        end
      end
    end

    it "defines an attribute" do
      define_output
      expect(example_state_class).to have_received(:define_attribute).with(output)
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :output do
      let(:root_class) { example_state_class }
    end
  end

  describe ".after_validation" do
    subject(:valid?) { instance.valid? }

    let(:instance) { example_class.new }

    let(:example_class) do
      Class.new do
        include ActiveModel::Model
        include ActiveModel::Validations::Callbacks
        include Flow::State::Defaults
        include Flow::State::Attributes
        include Flow::State::Output

        output :test_output0
        output :test_output1, default: :default_value1
        output(:test_output2) { :default_value2 }
      end
    end

    it "sets default values" do
      expect { valid? }.
        to change { instance.try(:test_output1) }.from(nil).to(:default_value1).
        and change { instance.try(:test_output2) }.from(nil).to(:default_value2)
    end
  end
end
