# frozen_string_literal: true

module CustomMatchers
  def have_on_state(expectations)
    HaveOnState.new(expectations)
  end

  class HaveOnState
    include RSpec::Matchers

    def initialize(state_expectations)
      @state_expectations = state_expectations
    end

    def matches?(object)
      @state_expectations.all? do |key, value|
        expect(object.state.public_send(key)).to match value
      end
    end

    def description
      "have the expected data on state"
    end
  end
end