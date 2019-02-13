# frozen_string_literal: true

module Flow
  module Generators
    class FlowGenerator < Rails::Generators::NamedBase
      class_option :state, type: :boolean, default: true

      source_root File.expand_path("templates", __dir__)

      hook_for :state, as: "flow:state"
      hook_for :test_framework

      def create_application_flow
        template "flow.rb.erb", File.join("app/flows/", class_path, "#{file_name}_flow.rb")
      end
    end
  end
end
