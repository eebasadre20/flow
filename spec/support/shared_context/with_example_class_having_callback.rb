# frozen_string_literal: true

RSpec.shared_context "with example class having callback" do |callback|
  let(:example_class_having_callback) do
    Class.new do
      include ActiveSupport::Callbacks
      define_callbacks callback

      @before_hook_run = false
      @after_hook_run = false

      class << self
        attr_writer :before_hook_run, :after_hook_run

        def before_hook_run?
          @before_hook_run
        end

        def after_hook_run?
          @after_hook_run
        end
      end

      set_callback(callback, :before) { |obj| obj.class.before_hook_run = true }
      set_callback(callback, :after) { |obj| obj.class.after_hook_run = true }
    end
  end
end
