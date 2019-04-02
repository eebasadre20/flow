# Flow

[![Gem Version](https://badge.fury.io/rb/flow.svg)](https://badge.fury.io/rb/flow)
[![Build Status](https://semaphoreci.com/api/v1/freshly/flow/branches/master/badge.svg)](https://semaphoreci.com/freshly/flow)
[![Maintainability](https://api.codeclimate.com/v1/badges/02131658005b10c289e0/maintainability)](https://codeclimate.com/github/Freshly/flow/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/02131658005b10c289e0/test_coverage)](https://codeclimate.com/github/Freshly/flow/test_coverage)

* [Installation](#installation)
* [What is Flow?](#what-is-flow)
* [How it Works](#how-it-works)
   * [Flows](#flows)
   * [Operations](#operations)
   * [States](#states)
* [Errors](#errors)
   * [Exceptions](#exceptions)
   * [Failures](#failures)
   * [Statuses](#statuses)
* [Reverting a Flow](#reverting-a-flow)
   * [Undoing Operations](#undoing-operations)
* [Transactions](#transactions)
   * [Around a Flow](#around-a-flow)
   * [Around an Operation](#around-an-operation)
   * [Input](#input)
   * [Validations](#validations)
   * [Derivative Data](#derivative-data)
   * [Mutable Data](#mutable-data)
* [Utilities](#utilities)
   * [Callbacks](#callbacks)
   * [Memoization](#memoization)
   * [Logging](#logging)
* [Testing](#testing)
   * [Testing Setup](#testing-setup)
   * [Testing Flows](#testing-flows)
   * [Testing Operations](#testing-operations)
   * [Testing States](#testing-states)
   * [Integration Testing](#integration-testing)
* [Contributing](#contributing)
   * [Development](#development)
* [License](#license)


## Installation

Add this line to your application's Gemfile:

```ruby
gem "flow"
```

Then, in your project directory:

```bash
$ bundle install
$ rails generate flow:install
```

## What is Flow?

Flow is a [SOLID](https://en.wikipedia.org/wiki/SOLID) implementation of the [Command Pattern](https://en.wikipedia.org/wiki/Command_pattern) for Ruby on Rails.

Flows allow you to encapsulate your application's [business logic](http://en.wikipedia.org/wiki/Business_logic) in using a set of discrete, extensible, and reusable objects.

## How it Works

![Flow Basics](docs/images/flow.png)

There are three important concepts to distinguish here: [Flows](#Flows), [Operations](#Operations), and [States](#States).

### Flows

A **Flow** is a collection of procedurally executed **Operations** sharing a common **State**.

TODO...

### Operations

An **Operation** is a service object which is executed with a **State**.

TODO...

### States

A **State** is an aggregation of input and derived data.

TODO...

## Errors

TODO...

### Exceptions

TODO...

### Failures

TODO...

### Statuses

TODO...

## Reverting a Flow

TODO...

### Undoing Operations

TODO...

## Transactions

TODO...

### Around a Flow

TODO...

### Around an Operation

TODO...

### Input

TODO...

### Validations

TODO...

### Derivative Data

TODO...

### Mutable Data

TODO...

## Utilities

TODO...

### Callbacks

TODO...

### Memoization

TODO...

### Logging

TODO...

## Testing

If you plan on writing `RSpec` tests `Flow` comes packaged with some custom matchers.

### Testing Setup

Add the following to your `spec/rails_helper.rb` file:

```ruby
require "flow/spec_helper"
```

Flow works best with [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) and [rspice](https://github.com/Freshly/spicerack/tree/develop/rspice).

Add those to the `development` and `test` group of your Gemfile:

```ruby
group :development, :test do 
  gem "shoulda-matchers", git: "https://github.com/thoughtbot/shoulda-matchers.git", branch: "rails-5"
  gem "rspice"
end
```

Then run `bundle install` and add the following into `spec/rails_helper.rb`:

```ruby
require "rspec/rails"
require "rspice"
require "flow/spec_helper"

# Configuration for the shoulda-matchers gem
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

This will allow you to use the [define_argument](lib/flow/custom_matchers/define_argument.rb), [define_option](lib/flow/custom_matchers/define_option.rb), and [use_operations](lib/flow/custom_matchers/use_operations.rb) helpers.

### Testing Flows

TODO...

### Testing Operations

TODO...

### Testing States

TODO...

### Integration Testing

TODO...

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/freshly/flow.

### Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
