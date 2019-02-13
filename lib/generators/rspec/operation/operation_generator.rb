# frozen_string_literal: true

module Rspec
  module Generators
    class OperationGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "operation_spec.rb.erb", File.join("spec/operations/", class_path, "#{file_name}_spec.rb")
      end
    end
  end
end
