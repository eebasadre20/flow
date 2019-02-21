# frozen_string_literal: true

RSpec.describe Operation::Failures::OperationFailure, type: :subclass do
  subject(:example_failure) { described_class.new(problem, **details) }

  let(:problem) { Faker::Internet.domain_word.downcase.to_sym }
  let(:details) { Hash[*Faker::Lorem.words(4)].symbolize_keys }

  it { is_expected.to inherit_from StandardError }

  describe "#initialize" do
    it "structures the details of the given problem" do
      expect(example_failure.message).to eq problem.to_s
      expect(example_failure.problem).to eq problem
      expect(example_failure.details).to eq OpenStruct.new(details)
    end
  end
end
