# frozen_string_literal: true

RSpec.describe Flow::Operations, type: :module do
  include_context "with example flow having state", described_class

  describe ".operations" do
    subject(:operations) { example_flow_class.__send__(:operations, new_operations) }

    let(:new_operations) { [ double, double ] }

    it "changes _operations" do
      expect { operations }.to change { example_flow_class._operations }.from([]).to(new_operations)
    end
  end

  describe ".inherited" do
    let(:base_class) do
      Class.new(example_flow_class) do
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
end
