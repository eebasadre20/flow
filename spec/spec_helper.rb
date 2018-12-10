require "bundler/setup"
require "simplecov"

require "rspice"
require "shoulda-matchers"

require_relative "support/shared_context/with_an_example_operation"

SimpleCov.start do
  add_filter "/spec/"
end

require "flow"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_model
  end
end