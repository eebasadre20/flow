# frozen_string_literal: true

RSpec.describe Flow::Operation::Accessors, type: :module do
  subject { test_class.new }

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

  describe ".state_reader" do
    before { test_class.__send__(:state_reader, state_attribute) }

    it { is_expected.to delegate_method(state_attribute).to(:state) }
  end

  describe ".state_writer" do
    before { test_class.__send__(:state_writer, state_attribute) }

    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }
  end

  describe ".state_accessor" do
    before { test_class.__send__(:state_accessor, state_attribute) }

    it { is_expected.to delegate_method(state_attribute).to(:state) }
    it { is_expected.to delegate_method(state_attribute_writer).to(:state).with_arguments(state_attribute_value) }
  end
end
