# frozen_string_literal: true

module Flow
  module Generators
    class ApplicationStateGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      hook_for :test_framework

      def create_application_state
        template "application_state.rb", File.join("app/states/application_state.rb")
      end
    end
  end
end
