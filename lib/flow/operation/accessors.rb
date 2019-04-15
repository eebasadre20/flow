# frozen_string_literal: true

module Flow
  module Operation
    module Accessors
      extend ActiveSupport::Concern

      class_methods do
        protected

        def state_reader(name)
          delegate name, to: :state
        end

        def state_writer(name)
          delegate "#{name}=", to: :state
        end

        def state_accessor(name)
          state_reader name
          state_writer name
        end
      end
    end
  end
end
