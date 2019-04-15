# frozen_string_literal: true

RSpec.describe Flow::Operation::Accessors, type: :module do
  subject { test_class }

  let(:example_class) { Class.new.include described_class }
  let(:test_class) do
    Class.new(example_class) do
      def state
        @state ||= StateClass.new
      end
    end
  end
  let(:test_state_class) { Class.new }
  let(:state_attribute) { Faker::Lorem.word }
  let(:state_attribute_writer) { "#{state_attribute}=" }

  before { test_state_class.attr_accessor(state_attribute) }

  describe ".state_reader" do
    before { test_class.__send__(:state_reader, state_attribute) }

    it { is_expected.to delegate_method(state_attribute).to(:state) }
  end

  describe ".state_writer" do
    before { test_class.__send__(:state_writer, state_attribute) }

    it { is_expected.to delegate_method(state_attribute_writer).to(:state) }
  end

  describe ".state_accessor" do
    before { test_class.__send__(:state_accessor, state_attribute) }

    it { is_expected.to delegate_method(state_attribute).to(:state) }
    it { is_expected.to delegate_method(state_attribute_writer).to(:state) }
  end
end
