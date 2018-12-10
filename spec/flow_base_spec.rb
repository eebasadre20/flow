# frozen_string_literal: true

RSpec.describe FlowBase, type: :flow do
  subject(:flow) { example_flow_class.new }

  let(:example_flow_class) { Class.new(described_class) }
  let(:example_state_class) { Class.new(StateBase) }
  let(:example_flow_name) { Faker::Internet.domain_word.capitalize }

  it { is_expected.to include_module Technologic }

  before do
    stub_const("#{example_flow_name}Flow", example_flow_class)
    stub_const("#{example_flow_name}State", example_state_class)
  end

  it { is_expected.to delegate_method(:state_class).to(:class) }

  describe ".trigger" do
    it_behaves_like "a class pass method", :trigger
  end

  describe ".state_class" do
    subject { example_flow_class.state_class }

    it { is_expected.to eq example_state_class }
  end

  describe ".operations" do
    subject(:operations) { example_flow_class.__send__(:operations, new_operations) }

    let(:new_operations) { [ double, double ] }

    it "changes _operations" do
      expect { operations }.to change { example_flow_class._operations }.from([]).to(new_operations)
    end
  end

  describe ".inherited" do
    let(:base_class) do
      Class.new(described_class) do
        operations :base
      end
    end

    let(:parentA_class) do
      Class.new(base_class) do
        operations :parentA
      end
    end

    let(:parentB_class) do
      Class.new(base_class) do
        operations :parentB
      end
    end

    let!(:childA1_class) do
      Class.new(parentA_class) do
        operations :childA1
      end
    end

    let!(:childA2_class) do
      Class.new(parentA_class) do
        operations :childA2
      end
    end

    let!(:childB_class) do
      Class.new(parentB_class) do
        operations :childB
      end
    end

    shared_examples_for "an object with inherited operations" do
      it "has expected _options" do
        expect(example_class._operations).to match_array expected_operations
      end
    end

    describe "#base_class" do
      subject(:example_class) { base_class }

      let(:expected_operations) { %i[base] }

      include_examples "an object with inherited operations"
    end

    describe "#parentA" do
      subject(:example_class) { parentA_class }

      let(:expected_operations) { %i[base parentA] }

      include_examples "an object with inherited operations"
    end

    describe "#parentB" do
      subject(:example_class) { parentB_class }

      let(:expected_operations) { %i[base parentB] }

      include_examples "an object with inherited operations"
    end

    describe "#childA1" do
      subject(:example_class) { childA1_class }

      let(:expected_operations) { %i[base parentA childA1] }

      include_examples "an object with inherited operations"
    end

    describe "#childA2" do
      subject(:example_class) { childA2_class }

      let(:expected_operations) { %i[base parentA childA2] }

      include_examples "an object with inherited operations"
    end

    describe "#childB" do
      subject(:example_class) { childB_class }

      let(:expected_operations) { %i[base parentB childB] }

      include_examples "an object with inherited operations"
    end
  end

  describe "#initialize" do
    subject(:flow) { example_flow_class.new(**options) }

    let(:options) { Hash[*Faker::Lorem.words(2 * rand(1..2))].symbolize_keys }
    let(:flow_state) { instance_double(StateBase) }

    before { allow(example_state_class).to receive(:new).with(**options).and_return(flow_state) }

    it "sets state" do
      expect(flow.state).to eq flow_state
    end
  end

  describe "#trigger" do
    subject(:trigger) { flow.trigger }

    let(:operation0) { double }
    let(:operation1) { double }
    let(:operation2) { double }
    let(:operations) { [ operation0, operation1, operation2 ] }
    let(:state) { instance_double(example_state_class) }

    before do
      example_flow_class._operations = operations.each { |operation| allow(operation).to receive(:execute) }
      allow(flow).to receive(:state).and_return(state)
    end

    it { is_expected.to eq state }

    it "executes operations" do
      trigger
      expect(operations).to all(have_received(:execute).with(state).ordered)
    end

    it "is surveiled" do
      allow(flow).to receive(:surveil).with(:trigger) do |&block|
        block.call
        expect(operations).to all(have_received(:execute).with(state).ordered)
      end
    end
  end
end
