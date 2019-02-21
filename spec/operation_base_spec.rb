# frozen_string_literal: true

RSpec.describe OperationBase, type: :operation do
  subject { described_class }

  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module Operation::Core }
  it { is_expected.to include_module Operation::Execute }
end
