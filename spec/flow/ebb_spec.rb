# frozen_string_literal: true

RSpec.describe Flow::Ebb, type: :module do
  include_context "with example flow having state", [ Flow::Operations, Flow::Flux, described_class ]

  describe "#rewound_operations" do
    subject { example_flow.__send__(:rewound_operations) }

    it { is_expected.to eq [] }
  end

  describe "#ebb" do
    include_context "with operations for a flow"

    subject(:ebb) { example_flow.ebb }

    let(:state) { instance_double(Class.new(Flow::StateBase)) }

    it_behaves_like "a class with callback" do
      include_context "with flow callbacks", :ebb

      subject(:callback_runner) { ebb }

      let(:example) { example_flow }
    end

    before do
      allow(example_flow).to(receive(:executed_operations)).and_return(operations)
    end

    context "when nothing goes wrong" do
      before do
        operations.each { |operation| allow(operation).to receive(:rewind).and_call_original }
      end

      it "rewinds all operations" do
        expect { ebb }.
          to change { example_flow.__send__(:rewound_operations) }.
          from([]).
          to(instance_of_operations.reverse)
        expect(operations.reverse).to all(have_received(:rewind).ordered)
      end

      context "with already rewound operations" do
        before do
          example_flow.__send__(:rewound_operations) << operations.last
        end

        it "rewinds all unrewound operations" do
          expect { ebb }.
            to change { example_flow.__send__(:rewound_operations) }.
            from([ operations.last ]).
            to(operations.reverse)
          expect(operations.last).not_to have_received(:rewind)
          expect(operations.first(2).reverse).to all(have_received(:rewind).ordered)
        end
      end
    end

    context "when an operation raises" do
      let(:example_error) { Class.new(StandardError) }

      before do
        operations.each_with_index do |operation, index|
          if index == 1
            allow(operation).to receive(:rewind).and_raise example_error
          else
            allow(operation).to receive(:rewind).and_call_original
          end
        end
      end

      it "raises" do
        expect { ebb }.
          to raise_error(example_error).
          and change { example_flow.__send__(:rewound_operations) }.from([]).to([ operations.last ])
        expect(operations.first).not_to have_received(:rewind)
      end
    end
  end
end
