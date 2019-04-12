# frozen_string_literal: true

RSpec.describe Flow::StateBase, type: :state do
  subject { described_class }

  it { is_expected.to include_module ShortCircuIt }
  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module ActiveModel::Model }
  it { is_expected.to include_module Flow::State::Callbacks }
  it { is_expected.to include_module Flow::State::Defaults }
  it { is_expected.to include_module Flow::State::Attributes }
  it { is_expected.to include_module Flow::State::Arguments }
  it { is_expected.to include_module Flow::State::Options }
  it { is_expected.to include_module Flow::State::Core }
  it { is_expected.to include_module Flow::State::String }
end
