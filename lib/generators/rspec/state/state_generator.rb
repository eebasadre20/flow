# frozen_string_literal: true

module Rspec
  module Generators
    class StateGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "state_spec.rb.erb", File.join("spec/states/", class_path, "#{file_name}_state_spec.rb")
      end
    end
  end
end
