# frozen_string_literal: true

module Rspec
  module Generators
    class ApplicationStateGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "application_state_spec.rb", File.join("spec/states/application_state_spec.rb")
      end
    end
  end
end
