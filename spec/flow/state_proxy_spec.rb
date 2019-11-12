# frozen_string_literal: true

RSpec.describe Flow::StateProxy, type: :state_proxy do
  include_context "with an example state"

  subject(:state_proxy) { described_class.new(state, state_readers, state_writers) }

  let(:state) { example_state }
  let(:state_readers) { [] }
  let(:state_writers) { [] }

  it { is_expected.to inherit_from Spicerack::RootObject }

  describe "#respond_to?" do
    subject { state_proxy.respond_to?(method_name) }

    let(:example_method_name) do
      Array.new(2) { Faker::Internet.domain_word }.join("_")
    end
    let(:method_name) { example_method_name.to_sym }

    before { allow(example_state).to receive(:respond_to?).with(method_name).and_return(state_respond_to?) }

    context "without state.respond_to?" do
      let(:state_respond_to?) { false }

      it { is_expected.to eq false }
    end

    context "when state.respond_to?" do
      let(:state_respond_to?) { true }

      context "without accessors" do
        it { is_expected.to eq true }
      end

      context "with reader" do
        context "when specified" do
          let(:state_readers) { [ method_name ] }

          it { is_expected.to eq true }
        end

        context "when unspecified" do
          let(:state_readers) { [ SecureRandom.hex.to_sym ] }

          it { is_expected.to eq false }
        end
      end

      context "with writer" do
        let(:method_name) { "#{example_method_name}=".to_sym }

        context "when specified" do
          let(:state_writers) { [ example_method_name.to_sym ] }

          it { is_expected.to eq true }
        end

        context "when unspecified" do
          let(:state_writers) { [ SecureRandom.hex.to_sym ] }

          it { is_expected.to eq false }
        end
      end
    end
  end

  describe "#method_missing" do
    subject(:call) { state_proxy.public_send(method_name, *arguments) }

    let(:arguments) { [] }
    let(:example_method_name) do
      Array.new(2) { Faker::Internet.domain_word }.join("_")
    end
    let(:method_name) { example_method_name.to_sym }
    let(:value_from_state) { double }

    before { allow(example_state).to receive(:respond_to?).with(method_name).and_return(state_respond_to?) }

    shared_examples_for "a NoMethodError is raised" do
      it "raises NoMethodError" do
        expect { call }.to raise_error NoMethodError, "undefined method `#{method_name}' for #{state_proxy}"
      end
    end

    context "without state.respond_to?" do
      let(:state_respond_to?) { false }

      it_behaves_like "a NoMethodError is raised"
    end

    context "when state.respond_to?" do
      let(:state_respond_to?) { true }

      context "without accessors" do
        before { allow(example_state).to receive(method_name).with(no_args).and_return(value_from_state) }

        it { is_expected.to eq value_from_state }
      end

      context "with reader" do
        before { allow(example_state).to receive(method_name).with(no_args).and_return(value_from_state) }

        context "when specified" do
          let(:state_readers) { [ method_name ] }

          it { is_expected.to eq value_from_state }
        end

        context "when unspecified" do
          let(:state_readers) { [ SecureRandom.hex.to_sym ] }

          it_behaves_like "a NoMethodError is raised"
        end
      end

      context "with writer" do
        before { allow(example_state).to receive(method_name).with(*arguments).and_return(value_from_state) }

        let(:arguments) { [ Faker::Lorem.word ] }
        let(:method_name) { "#{example_method_name}=".to_sym }

        context "when specified" do
          let(:state_writers) { [ example_method_name.to_sym ] }

          it { is_expected.to eq value_from_state }
        end

        context "when unspecified" do
          let(:state_writers) { [ SecureRandom.hex.to_sym ] }

          it_behaves_like "a NoMethodError is raised"
        end
      end
    end
  end
end
