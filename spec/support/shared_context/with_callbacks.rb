# frozen_string_literal: true

RSpec.shared_context "with callbacks" do |callback|
  before do
    example_class.attr_accessor :before_hook_run, :around_hook_run, :after_hook_run
    example_class.set_callback(callback, :before) { |obj| obj.before_hook_run = true }
    example_class.set_callback(callback, :after) { |obj| obj.after_hook_run = true }
    example_class.set_callback callback, :around do |obj, block|
      obj.around_hook_run = true
      block.call
    end
  end
end
