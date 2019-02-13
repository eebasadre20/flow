# frozen_string_literal: true

module Rspec
  module Generators
    class FlowGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "flow_spec.rb.erb", File.join("spec/flows/", class_path, "#{file_name}_flow_spec.rb")
      end
    end
  end
end
