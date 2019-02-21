# frozen_string_literal: true

RSpec.describe State::Core, type: :module do
  describe "#initialize" do
    include_context "with example class having callback", :initialize

    subject(:instance) { example_class.new(**arguments) }

    let(:arguments) { Hash[*Faker::Lorem.words(4)].symbolize_keys }
    let(:example_class) { example_class_having_callback.include(State::Core) }

    context "when no writers are defined for the arguments" do
      it "raises" do
        expect { instance }.to raise_error NoMethodError
      end
    end

    context "when writers are defined for the arguments" do
      before do
        arguments.each_key { |argument| example_class.attr_accessor argument }
      end

      it "assigns arguments to the attribute readers" do
        arguments.each { |argument, value| expect(instance.public_send(argument)).to eq value }
      end

      it "runs the callbacks" do
        expect { instance }.
          to change { example_class.before_hook_run? }.from(false).to(true).
          and change { example_class.around_hook_run? }.from(false).to(true).
          and change { example_class.after_hook_run? }.from(false).to(true)
      end
    end
  end
end
