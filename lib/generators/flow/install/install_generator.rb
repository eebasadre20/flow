# frozen_string_literal: true

module Flow
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def run_other_generators
        generate "flow:application_flow"
        generate "flow:application_operation"
        generate "flow:application_state"
      end
    end
  end
end
