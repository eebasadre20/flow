# frozen_string_literal: true

module Flow
  module Generators
    class StateGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      hook_for :test_framework

      def create_application_state
        template "state.rb.erb", File.join("app/states/", class_path, "#{file_name}_state.rb")
      end
    end
  end
end
