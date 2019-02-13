# frozen_string_literal: true

require "flow"

module Flow
  module Generators
    module Rspec
      class ConstructorGenerator < Rails::Generators::NamedBase
        source_root File.expand_path("templates", __dir__)

        def create_spec_file
          template "application_flow_spec.rb", File.join("spec/constructors/application_flow_spec.rb")
        end
      end
    end
  end
end

