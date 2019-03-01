# frozen_string_literal: true

RSpec.describe StateBase, type: :state do
  subject { described_class }

  it { is_expected.to include_module ShortCircuIt }
  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module ActiveModel::Model }
  it { is_expected.to include_module State::Attributes }
  it { is_expected.to include_module State::Arguments }
  it { is_expected.to include_module State::Callbacks }
  it { is_expected.to include_module State::Core }
  it { is_expected.to include_module State::Options }
  it { is_expected.to include_module State::String }
end
