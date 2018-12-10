# frozen_string_literal: true

# A flow is a collection of procedurally executed operations sharing a common state.
class FlowBase
  include Technologic

  class_attribute :_operations, instance_writer: false, default: []

  class << self
    def state_class
      "#{name.chomp("Flow")}State".constantize
    end

    def trigger(*arguments)
      new(*arguments).trigger
    end

    def operations(*operations)
      _operations.concat(operations.flatten)
    end

    def inherited(base)
      base._operations = _operations.dup
      super
    end
  end

  attr_reader :state

  delegate :state_class, :_operations, to: :class

  def initialize(**input)
    @state = state_class.new(**input)
  end

  def trigger
    surveil(:trigger) do
      _operations.each { |operation| operation.execute(state) }
    end

    state
  end
end
