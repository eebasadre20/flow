# frozen_string_literal: true

RSpec.describe OperationBase, type: :operation do
  subject { described_class }

  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module Operation::Callbacks }
  it { is_expected.to include_module Operation::Core }
  it { is_expected.to include_module Operation::Execute }
  it { is_expected.to include_module Operation::Failures }
  it { is_expected.to include_module Operation::ErrorHandler }
  it { is_expected.to include_module Operation::Rewind }
  it { is_expected.to include_module Operation::Status }
  it { is_expected.to include_module TransactionWrapper }
end
