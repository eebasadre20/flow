# frozen_string_literal: true

RSpec.describe Operation::ErrorHandler, type: :module do
  include_context "with an example operation", [ Operation::Failures, Operation::Execute, Operation::ErrorHandler ]

  describe ".handle_error" do
    let(:example_error) { Class.new(StandardError) }
    let(:example_error_name) { Faker::Internet.domain_word.capitalize }

    before do
      stub_const(example_error_name, example_error)
      allow(example_operation_class).to receive(:failure).and_call_original
    end

    context "without given problem" do
      subject(:handle_error) { example_operation_class.__send__(:handle_error, example_error) }

      context "when the class is within a module" do
        let(:example_error_name) { "#{Faker::Internet.domain_word.capitalize}::#{root_error_name}" }
        let(:root_error_name) { Array.new(2) { Faker::Internet.domain_word.capitalize }.join("") }

        it "uses demodulized class name" do
          handle_error
          expect(example_operation_class).to have_received(:failure).with(root_error_name.underscore)
        end
      end

      context "when the class is NOT within a module" do
        let(:example_error_name) { Array.new(2) { Faker::Internet.domain_word.capitalize }.join("") }

        it "uses class name" do
          handle_error
          expect(example_operation_class).to have_received(:failure).with(example_error_name.underscore)
        end
      end
    end

    context "with given problem" do
      subject(:handle_error) { example_operation_class.__send__(:handle_error, example_error, problem: problem) }

      let(:problem) { Faker::Internet.domain_word.underscore }

      context "when the class is NOT within a module" do
        it "uses problem" do
          handle_error
          expect(example_operation_class).to have_received(:failure).with(problem)
        end
      end
    end

    context "when the handled error is raised" do
      subject(:execute!) { example_operation.execute! }

      let(:problem) { Faker::Internet.domain_word.underscore }
      let(:example_failure) { Operation::Failures::OperationFailure.new(problem, exception: example_error.new) }

      before do
        allow(example_operation).to receive(:behavior).and_raise(example_error)
        allow(Operation::Failures::OperationFailure).
          to receive(:new).
          with(problem, exception: instance_of(example_error)).
          and_return(example_failure)
      end

      context "when no handler is defined" do
        before { example_operation_class.__send__(:handle_error, example_error, problem: problem) }

        it "wraps error in failure" do
          expect { execute! }.to raise_error(example_failure)
        end
      end

      context "when an error handler is defined" do
        let(:method_name) { Faker::Internet.domain_word.downcase.to_sym }
        let(:error_handler) do
          ->(exception) { self.last_exception = exception }
        end

        before { example_operation_class.attr_accessor :last_exception }

        shared_examples_for "a handled error" do
          it "doesn't raise" do
            expect { execute! }.not_to raise_error
          end

          it "handles the exception" do
            expect { execute! }.to change { example_operation.last_exception }.from(nil).to(instance_of(example_error))
          end
        end

        context "with a method handler" do
          before do
            example_operation_class.define_method(method_name, &error_handler)
            example_operation_class.__send__(:handle_error, example_error, problem: problem, with: method_name)
          end

          it_behaves_like "a handled error"
        end

        context "with a block handler" do
          before { example_operation_class.__send__(:handle_error, example_error, problem: problem, &error_handler) }

          it_behaves_like "a handled error"
        end
      end
    end
  end
end
