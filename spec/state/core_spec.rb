# frozen_string_literal: true

RSpec.describe State::Core, type: :module do
  describe "#initialize" do
    subject(:instance) { example_class.new(**arguments) }

    let(:arguments) { Hash[*Faker::Lorem.words(4)].symbolize_keys }
    let(:example_class) do
      Class.new do
        include ActiveSupport::Callbacks
        define_callbacks :initialize

        @before_hook_run = false
        @after_hook_run = false

        class << self
          attr_writer :before_hook_run, :after_hook_run

          def before_hook_run?
            @before_hook_run
          end

          def after_hook_run?
            @after_hook_run
          end
        end

        set_callback(:initialize, :before) { |obj| obj.class.before_hook_run = true }
        set_callback(:initialize, :after) { |obj| obj.class.after_hook_run = true }

        include State::Core
      end
    end

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
          and change { example_class.after_hook_run? }.from(false).to(true)
      end
    end
  end
end
