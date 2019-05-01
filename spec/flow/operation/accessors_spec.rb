# frozen_string_literal: true

RSpec.describe Flow::Operation::Accessors, type: :module do
  subject(:stateful_instance) { test_class.new }

  let(:example_class) { Class.new.include described_class }
  let(:test_class) do
    Class.new(example_class) do
      def state
        @state ||= StateClass.new
      end
    end
  end
  let(:test_state_class) { Class.new }
  let(:state_attribute) { Faker::Lorem.word.to_sym }
  let(:state_attribute_writer) { "#{state_attribute}=".to_sym }
  let(:state_attribute_value) { Faker::Hipster.word }

  before do
    stub_const("StateClass", test_class)
    test_state_class.attr_accessor(state_attribute)
  end

  shared_examples_for "it has exactly one tracker variable of type" do |tracker_type|
    let(:tracker_name) { "_state_#{tracker_type}".pluralize }

    it "sets a tracker variable" do
      expect(subject.public_send(tracker_name).count(state_attribute)).to eq 1
    end
  end

  shared_examples_for "it has no tracker variables of type" do |tracker_type, attribute|
    let(:tracker_name) { "_state_#{tracker_type}".pluralize }

    it "doesn't set a tracker variable" do
      expect(subject.public_send(tracker_name).count(state_attribute)).to eq 0
    end
  end

  describe ".state_reader" do
    subject do
      test_class.__send__(:state_reader, state_attribute)
      test_class.new
    end

    it { is_expected.to delegate_method(state_attribute).to(:state) }

    it_behaves_like "it has exactly one tracker variable of type", :reader
    it_behaves_like "it has no tracker variables of type", :accessor

    context "when a reader has already been defined" do
      before { test_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has no tracker variables of type", :accessor
    end

    context "when a writer has already been defined" do
      before { test_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end

  describe ".state_writer" do
    before { test_class.__send__(:state_writer, state_attribute) }

    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }

    it_behaves_like "it has exactly one tracker variable of type", :writer
    it_behaves_like "it has no tracker variables of type", :accessor

    context "when a writer has already been defined" do
      before { test_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has no tracker variables of type", :accessor
    end

    context "when a writer has already been defined" do
      before { test_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end

  describe ".state_accessor" do
    before { test_class.__send__(:state_accessor, state_attribute) }

    it { is_expected.to delegate_method(state_attribute).to(:state) }
    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }

    it_behaves_like "it has exactly one tracker variable of type", :writer
    it_behaves_like "it has exactly one tracker variable of type", :reader
    it_behaves_like "it has exactly one tracker variable of type", :accessor

    context "when a writer has already been defined" do
      before { test_class.__send__(:state_writer, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end

    context "when a writer has already been defined" do
      before { test_class.__send__(:state_reader, state_attribute) }

      it_behaves_like "it has exactly one tracker variable of type", :writer
      it_behaves_like "it has exactly one tracker variable of type", :reader
      it_behaves_like "it has exactly one tracker variable of type", :accessor
    end
  end
end
