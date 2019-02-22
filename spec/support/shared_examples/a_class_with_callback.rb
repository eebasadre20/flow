# frozen_string_literal: true

RSpec.shared_examples_for "an class with callback" do
  it "runs the callbacks" do
    expect { callback_runner }.
      to change { example_class.before_hook_run }.from(nil).to(true).
      and change { example_class.around_hook_run }.from(nil).to(true).
      and change { example_class.after_hook_run }.from(nil).to(true)
  end
end
