# frozen_string_literal: true

RSpec.describe Flow::State::Output, type: :module do
  include_context "with an example state", [
    ActiveModel::Model,
    ActiveModel::Validations::Callbacks,
    Flow::State::Status,
    Flow::State::Defaults,
    Flow::State::Attributes,
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
    subject(:valid?) { example_state.valid? }

    let(:example_state) { example_class.new }
    let(:example_class) do
      Class.new(example_state_class) do
        output :test_output0
        output :test_output1, default: :default_value1
        output(:test_output2) { :default_value2 }
      end
    end

    before do
      stub_const(Faker::Internet.unique.domain_word.capitalize, example_state_class)
      stub_const(Faker::Internet.unique.domain_word.capitalize, example_class)
    end

    shared_examples_for "can't read or write output" do
      it "raises on attempted write" do
        expect { example_state.test_output0 = :test }.to raise_error Flow::State::Errors::NotValidated
        expect { example_state.test_output1 = :test }.to raise_error Flow::State::Errors::NotValidated
        expect { example_state.test_output2 = :test }.to raise_error Flow::State::Errors::NotValidated
      end

      it "raises on attempted read" do
        expect { example_state.test_output0 }.to raise_error Flow::State::Errors::NotValidated
        expect { example_state.test_output1 }.to raise_error Flow::State::Errors::NotValidated
        expect { example_state.test_output2 }.to raise_error Flow::State::Errors::NotValidated
      end
    end

    context "without running validations" do
      it_behaves_like "can't read or write output"
    end

    context "with errors" do
      before do
        example_class.__send__(:define_attribute, :name)
        example_class.validates :name, presence: true
        valid?
      end

      it_behaves_like "can't read or write output"
    end

    context "without errors" do
      it "sets default values" do
        valid?

        expect(example_state.test_output1).to eq :default_value1
        expect(example_state.test_output2).to eq :default_value2
      end

      it "allows read/write of output" do
        valid?

        expect { example_state.test_output0 = :x }.to change { example_state.test_output0 }.from(nil).to(:x)
        expect { example_state.test_output1 = :y }.to change { example_state.test_output1 }.from(:default_value1).to(:y)
        expect { example_state.test_output2 = :z }.to change { example_state.test_output2 }.from(:default_value2).to(:z)
      end
    end
  end
end
