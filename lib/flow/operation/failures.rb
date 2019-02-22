# frozen_string_literal: true

# When `#execute` is unsuccessful, expected problems are *failures* and unexpected problems are *Exceptions*.
module Operation
  module Failures
    extend ActiveSupport::Concern

    included do
      class_attribute :_failures, instance_writer: false, default: []

      delegate :_failures, to: :class
    end

    class_methods do
      def inherited(base)
        base._failures = _failures.dup
        super
      end

      private

      def failure(problem)
        problem = problem.to_s.to_sym
        warn(:problem_already_defined) if _failures.include? problem

        _failures << problem
        define_callbacks problem
        define_on_failure_for_problem(problem)
        define_fail_method_for_problem(problem)
      end

      def define_on_failure_for_problem(problem)
        on_failure_name = "on_#{problem}_failure".to_sym
        return if respond_to?(on_failure_name)

        define_singleton_method(on_failure_name) { |*filters, &block| set_callback(problem, :before, *filters, &block) }
      end

      def define_fail_method_for_problem(problem)
        problem_failure_name = "#{problem}_failure!".to_sym
        return if method_defined?(problem_failure_name)

        define_method(problem_failure_name) { |**details| fail!(problem, **details) }
      end
    end

    def fail!(problem, **details)
      run_callbacks(problem) do
        run_callbacks(:failure) do
          error! OperationFailure.new(problem, **details), **details
        end
      end
    end

    class OperationFailure < StandardError
      attr_reader :problem, :details

      def initialize(problem = nil, **details)
        super(problem)
        @problem = problem
        @details = OpenStruct.new(details)
      end
    end
  end
end
