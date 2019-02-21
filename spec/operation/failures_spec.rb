# frozen_string_literal: true

RSpec.describe Operation::Failures, type: :module do
  include_context "with an example operation", [ Operation::Execute, Operation::Failures ]

  let(:problem) { Faker::Lorem.word.to_sym }

  describe ".failure" do
    subject(:define_failure) { example_operation_class.__send__(:failure, problem) }

    it "adds to _failures" do
      expect { define_failure }.to change { example_operation_class._failures }.from([]).to([ problem ])
    end

    it "defines a callback" do
      expect { define_failure }.
        to change { example_operation_class.__callbacks.keys }.
        from(%i[failure]).
        to(%I[failure #{problem}])
    end

    it "defines #on_<problem>_failure" do
      expect { define_failure }.
        to change { example_operation_class.respond_to?("on_#{problem}_failure".to_sym) }.
        from(false).
        to(true)
    end

    it "defines #<problem>_failure!" do
      expect { define_failure }.
        to change { example_operation_class.method_defined?("#{problem}_failure!".to_sym) }.
        from(false).
        to(true)
    end
  end

  describe ".inherited" do
    let(:base_class) do
      Class.new(example_operation_class) { failure :base }
    end

    let(:parentA_class) do
      Class.new(base_class) do
        failure :parentA
      end
    end

    let(:parentB_class) do
      Class.new(base_class) do
        failure :parentB
      end
    end

    let!(:childA1_class) do
      Class.new(parentA_class) do
        failure :childA1
      end
    end

    let!(:childA2_class) do
      Class.new(parentA_class) do
        failure :childA2
      end
    end

    let!(:childB_class) do
      Class.new(parentB_class) do
        failure :childB
      end
    end

    shared_examples_for "an object with inherited failures" do
      it "has expected _failures" do
        expect(example_class._failures).to eq expected_failures
      end
    end

    describe "#base_class" do
      subject(:example_class) { base_class }

      let(:expected_failures) { %i[base] }

      include_examples "an object with inherited failures"
    end

    describe "#parentA" do
      subject(:example_class) { parentA_class }

      let(:expected_failures) { %i[base parentA] }

      include_examples "an object with inherited failures"
    end

    describe "#parentB" do
      subject(:example_class) { parentB_class }

      let(:expected_failures) { %i[base parentB] }

      include_examples "an object with inherited failures"
    end

    describe "#childA1" do
      subject(:example_class) { childA1_class }

      let(:expected_failures) { %i[base parentA childA1] }

      include_examples "an object with inherited failures"
    end

    describe "#childA2" do
      subject(:example_class) { childA2_class }

      let(:expected_failures) { %i[base parentA childA2] }

      include_examples "an object with inherited failures"
    end

    describe "#childB" do
      subject(:example_class) { childB_class }

      let(:expected_failures) { %i[base parentB childB] }

      include_examples "an object with inherited failures"
    end
  end

  describe "#on_<problem>_failure" do
    subject(:failure) { example_operation.run_callbacks(problem) }

    before do
      example_operation_class.__send__(:failure, problem)
      example_operation_class.attr_accessor :before_hook_run
      example_operation_class.public_send("on_#{problem}_failure".to_sym) { self.before_hook_run = true }
    end

    it "runs callback on failure" do
      expect { failure }.to change { example_operation.before_hook_run }.from(nil).to(true)
    end
  end

  describe "#<problem>_failure!" do
    subject(:problem_failure!) { example_operation.public_send("#{problem}_failure!".to_sym, **details) }

    let(:details) { Hash[*Faker::Lorem.words(4)].symbolize_keys }

    before do
      example_operation_class.__send__(:failure, problem)

      allow(example_operation).to receive(:fail!)
    end

    it "calls fail!" do
      problem_failure!
      expect(example_operation).to have_received(:fail!).with(problem, **details)
    end
  end

  describe "#fail!" do
    subject(:fail!) { example_operation.fail!(problem, **details) }

    let(:details) { Hash[*Faker::Lorem.words(4)].symbolize_keys }

    before do
      allow(example_operation).to receive(:error!).and_call_original

      example_operation_class.__send__(:failure, problem)
      example_operation_class.attr_accessor :before_failure_hook_run, :before_problem_hook_run
      example_operation_class.public_send(:on_failure) { self.before_failure_hook_run = true }
      example_operation_class.public_send("on_#{problem}_failure".to_sym) { self.before_problem_hook_run = true }
    end

    it "logs, raises, and runs callbacks" do
      expect { fail! }.to raise_error(Operation::Failures::OperationFailure, problem.to_s).
        and change { example_operation.before_failure_hook_run }.from(nil).to(true).
        and change { example_operation.before_problem_hook_run }.from(nil).to(true)

      expect(example_operation).
        to have_received(:error!).with(instance_of(Operation::Failures::OperationFailure), **details)
    end

    it "has the problem details" do
      fail!
    rescue Operation::Failures::OperationFailure => operation_failure
      expect(operation_failure.problem).to eq problem
      expect(operation_failure.details).to eq OpenStruct.new(details)
    end

    it "calls error!" do

    end
  end
end
