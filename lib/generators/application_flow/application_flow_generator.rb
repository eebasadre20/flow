# frozen_string_literal: true

require "flow"

module Flow
  class ApplicationFlowGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    hook_for :test_framework

    def create_application_flow_file
      template "application_flow.rb", File.join("app/flows/application_flow.rb")
    end
  end
end
