# frozen_string_literal: true

RSpec.shared_context "with operation callbacks" do |callback|
  before do
    example_operation_class.attr_accessor :before_hook_run, :around_hook_run, :after_hook_run
    example_operation_class.set_callback(callback, :before) { |obj| obj.before_hook_run = true }
    example_operation_class.set_callback(callback, :after) { |obj| obj.after_hook_run = true }
    example_operation_class.set_callback callback, :around do |obj, block|
      obj.around_hook_run = true
      block.call
    end
  end
end
