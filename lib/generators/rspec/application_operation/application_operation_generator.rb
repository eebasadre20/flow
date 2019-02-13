# frozen_string_literal: true

module Rspec
  module Generators
    class ApplicationOperationGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "application_operation_spec.rb", File.join("spec/operations/application_operation_spec.rb")
      end
    end
  end
end
