# frozen_string_literal: true

module Flow
  module Generators
    class ApplicationOperationGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      hook_for :test_framework

      def create_application_operation
        template "application_operation.rb", File.join("app/operations/application_operation.rb")
      end
    end
  end
end
