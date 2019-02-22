# frozen_string_literal: true

RSpec.shared_examples_for "a class with callback" do
  it "runs the callbacks" do
    expect { callback_runner }.
      to change { example.before_hook_run }.from(nil).to(true).
      and change { example.around_hook_run }.from(nil).to(true).
      and change { example.after_hook_run }.from(nil).to(true)
  end
end
