# frozen_string_literal: true

module Rspec
  module Generators
    class ApplicationFlowGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "application_flow_spec.rb", File.join("spec/flows/application_flow_spec.rb")
      end
    end
  end
end
