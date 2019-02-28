# frozen_string_literal: true

RSpec.describe FlowBase, type: :flow do
  subject(:flow) { example_flow_class.new }

  let(:example_flow_class) { Class.new(described_class) }
  let(:example_state_class) { Class.new(StateBase) }
  let(:example_flow_name) { Faker::Internet.domain_word.capitalize }

  before do
    stub_const("#{example_flow_name}Flow", example_flow_class)
    stub_const("#{example_flow_name}State", example_state_class)
  end

  it { is_expected.to include_module ShortCircuIt }
  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module Flow::Callbacks }
  it { is_expected.to include_module Flow::Core }
  it { is_expected.to include_module Flow::Ebb }
  it { is_expected.to include_module Flow::Flux }
  it { is_expected.to include_module Flow::Operations }
  it { is_expected.to include_module Flow::Revert }
  it { is_expected.to include_module Flow::Transactions }
  it { is_expected.to include_module Flow::Trigger }
end
