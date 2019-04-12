# frozen_string_literal: true

RSpec.describe Flow::State::Options, type: :module do
  include_context "with an example state", [ Flow::State::Defaults, described_class ]

  describe ".option" do
    subject(:define_option) { example_state_class.__send__(:option, option) }

    let(:option) { Faker::Lorem.word.to_sym }

    before do
      allow(example_state_class).to receive(:define_default).and_call_original
      allow(example_state_class).to receive(:define_attribute).and_call_original
    end

    describe "defines option" do
      let(:default) { Faker::Lorem.word }

      shared_examples_for "an option is defined" do
        it "adds to _options" do
          expect { define_option }.to change { example_state_class._options }.from([]).to([ option ])
        end
      end

      context "when no block is given" do
        subject(:define_option) { example_state_class.__send__(:option, option, default: default) }

        it_behaves_like "an option is defined"

        it "defines an static default" do
          define_option
          expect(example_state_class).to have_received(:define_default).with(option, static: default)
        end
      end

      context "when a block is given" do
        subject(:define_option) { example_state_class.__send__(:option, option, default: default, &block) }

        let(:block) do
          ->(_) { :block }
        end

        shared_examples_for "values are handed off to define_default" do
          it "calls define_default" do
            define_option
            expect(example_state_class).to have_received(:define_default).with(option, static: default, &block)
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
      define_option
      expect(example_state_class).to have_received(:define_attribute).with(option)
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :option do
      let(:root_class) { example_state_class }
    end
  end

  describe ".after_initialize" do
    subject(:instance) { example_class.new(**options) }

    let(:example_class) do
      Class.new do
        include Flow::State::Callbacks
        include Flow::State::Defaults
        include Flow::State::Attributes
        include Flow::State::Core
        include Flow::State::Options

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
