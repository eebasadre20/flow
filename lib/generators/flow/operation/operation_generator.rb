# frozen_string_literal: true

module Flow
  module Generators
    class OperationGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      hook_for :test_framework

      def create_application_state
        template "operation.rb.erb", File.join("app/operations/", class_path, "#{file_name}.rb")
      end
    end
  end
end
