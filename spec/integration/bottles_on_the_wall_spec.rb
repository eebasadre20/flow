# frozen_string_literal: true

RSpec.describe Flow, type: :integration do
  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    ActiveRecord::Base.connection.create_table :bottles do |t|
      t.string :of, unique: true
      t.integer :number_on_the_wall, default: 99
      t.integer :number_passed_around, default: 0
    end
  end

  after(:all) { ActiveRecord::Base.connection.drop_table :bottles } # rubocop:disable RSpec/BeforeAfterAll

  after { RSpec::ExampleGroups::Flow::Bottle.destroy_all }

  class self::Bottle < ActiveRecord::Base
    validates :of, uniqueness: true
    validates :number_on_the_wall,
              :number_passed_around,
              numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :number_passed_around, numericality: { less_than_or_equal_to: 100 }

    def to_s
      return "No more bottles of #{of}" if number_on_the_wall == 0

      "#{number_on_the_wall} #{"bottle".pluralize(number_on_the_wall)} of #{of}"
    end
  end

  class self::BottlesOnTheWallState < StateBase
    argument :bottles_of

    option :starting_bottles
    option :number_to_take_down, default: 1
    option :output, default: []

    validates :number_to_take_down, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    def stanza
      output.join("\n")
    end

    def taking_down_one?
      number_to_take_down == 1
    end

    def bottles
      RSpec::ExampleGroups::Flow::Bottle.find_or_create_by(of: bottles_of) do |bottles|
        bottles.number_on_the_wall = starting_bottles if starting_bottles
      end
    end
    memoize :bottles
  end

  class self::CountOutCurrentBottles < OperationBase
    def behavior
      state.output.push "#{state.bottles} on the wall#{", #{state.bottles}" if state.output.empty?}."
    end
  end

  class self::TakeBottlesDown < OperationBase
    wrap_in_transaction except: :undo

    class NonTakedownError < StandardError; end

    failure :too_greedy
    handle_error NonTakedownError do
      state.output.push "You took nothing down."
    end

    on_failure do
      state.output.push "Something went wrong! It's the end of the song, and there's #{state.bottles} on the wall."
    end

    set_callback(:execute, :before) { bottle_count_term }
    set_callback(:execute, :after) { state.output.push "You take #{bottle_count_term} down." }

    def behavior
      too_greedy_failure! if state.number_to_take_down >= 5
      raise NonTakedownError if state.number_to_take_down == 0

      state.bottles.update!(number_on_the_wall: state.bottles.number_on_the_wall - state.number_to_take_down)
    end

    def undo
      state.bottles.reload.update!(number_on_the_wall: state.bottles.number_on_the_wall + state.number_to_take_down)
    end

    private

    def bottle_count_term
      return "it" if state.bottles.number_on_the_wall == 1
      return "one" if state.taking_down_one?

      state.number_to_take_down
    end
    memoize :bottle_count_term
  end

  class self::PassBottlesAround < OperationBase
    wrap_in_transaction only: :behavior

    class NonTakedownError < StandardError; end

    failure :too_generous
    handle_error ActiveRecord::RecordInvalid
    handle_error NonTakedownError, with: :non_takedown_handler

    on_record_invalid_failure do
      state.output.push "Passing the bottles wasn't as sound, now there's #{state.number_to_take_down} on the ground!"
    end

    set_callback(:execute, :after) { state.output.push "You pass #{state.taking_down_one? ? "it" : "them"} around." }

    def behavior
      too_generous_failure! if state.number_to_take_down >= 4
      raise NonTakedownError if state.number_to_take_down == 0

      state.bottles.update!(number_passed_around: state.bottles.number_passed_around + state.number_to_take_down)
    end

    def undo
      state.bottles.update!(number_passed_around: state.bottles.number_passed_around - state.number_to_take_down)
    end

    private

    def non_takedown_handler
      state.output.push "You pass nothing around."
    end
  end

  class self::BottlesOnTheWallFlow < FlowBase
    wrap_in_transaction only: :revert

    operations RSpec::ExampleGroups::Flow::CountOutCurrentBottles,
               RSpec::ExampleGroups::Flow::TakeBottlesDown,
               RSpec::ExampleGroups::Flow::PassBottlesAround,
               RSpec::ExampleGroups::Flow::CountOutCurrentBottles
  end

  subject(:flow) { RSpec::ExampleGroups::Flow::BottlesOnTheWallFlow.trigger(**input) }

  let(:bottles_of) { "beer" }
  let(:number_to_take_down) { nil }
  let(:starting_bottles) { nil }
  let(:output) { nil }
  let(:input) do
    {
      bottles_of: bottles_of,
      starting_bottles: starting_bottles,
      number_to_take_down: number_to_take_down,
      output: output,
    }.compact
  end

  shared_examples_for "a successful flow" do
    it { is_expected.to be_an_instance_of RSpec::ExampleGroups::Flow::BottlesOnTheWallFlow }

    it "has expected status" do
      expect(flow).to be_state_valid
      expect(flow).not_to be_pending
      expect(flow).to be_triggered
      expect(flow).to be_success
      expect(flow).not_to be_failed
      expect(flow).not_to be_reverted
    end
  end

  shared_examples_for "a failed flow" do
    it { is_expected.to be_an_instance_of RSpec::ExampleGroups::Flow::BottlesOnTheWallFlow }

    it "has expected status" do
      expect(flow).to be_state_valid
      expect(flow).not_to be_pending
      expect(flow).to be_triggered
      expect(flow).not_to be_success
      expect(flow).to be_failed
      expect(flow).to be_reverted
    end

    it "has a failed operation" do
      expect(flow).to be_failed_operation
      expect(flow.failed_operation.operation_failure).to be_an_instance_of Operation::Failures::OperationFailure
      expect(flow.failed_operation).to be_executed
      expect(flow.failed_operation).not_to be_success
    end
  end

  context "without bottles_of" do
    let(:bottles_of) { nil }

    it "raises" do
      expect { flow }.to raise_error ArgumentError, "Missing argument: bottles_of"
    end
  end

  context "with defaults" do
    let(:expected_string) { raw_string.delete("\n") }
    let(:raw_string) do
      <<~STRING.chomp
        #<RSpec::ExampleGroups::Flow::BottlesOnTheWallState
         bottles_of="beer"
         starting_bottles=nil
         number_to_take_down=1
         output=[
        "99 bottles of beer on the wall, 99 bottles of beer.",
         "You take one down.",
         "You pass it around.",
         "98 bottles of beer on the wall."
        ]
        >
      STRING
    end

    it_behaves_like "a successful flow"

    it "produces expected stanza" do
      expect(flow.state.stanza).to eq <<~STANZA.chomp
        99 bottles of beer on the wall, 99 bottles of beer.
        You take one down.
        You pass it around.
        98 bottles of beer on the wall.
      STANZA
    end

    describe "#state#to_s" do
      subject { flow.state.to_s }

      let(:raw_string) do
        <<~STRING.chomp
          #<RSpec::ExampleGroups::Flow::BottlesOnTheWallState
           bottles_of=beer
           starting_bottles=
           number_to_take_down=1
           output=[
          "99 bottles of beer on the wall, 99 bottles of beer.",
           "You take one down.",
           "You pass it around.",
           "98 bottles of beer on the wall."
          ]
          >
        STRING
      end

      it { is_expected.to eq expected_string }
    end

    describe "#state#inspect" do
      subject { flow.state.inspect }

      let(:raw_string) do
        <<~STRING.chomp
          #<RSpec::ExampleGroups::Flow::BottlesOnTheWallState
           bottles_of="beer"
           starting_bottles=nil
           number_to_take_down=1
           output=[
          "99 bottles of beer on the wall, 99 bottles of beer.",
           "You take one down.",
           "You pass it around.",
           "98 bottles of beer on the wall."
          ]
          >
        STRING
      end

      it { is_expected.to eq expected_string }
    end
  end

  context "with starting_bottles" do
    context "when invalid" do
      let(:starting_bottles) { -1 }

      it "raises" do
        expect { flow }.to raise_error ActiveRecord::RecordInvalid,
                                       "Validation failed: Number on the wall must be greater than or equal to 0"
      end
    end

    context "when one" do
      let(:starting_bottles) { 1 }

      it_behaves_like "a successful flow"

      it "produces expected stanza" do
        expect(flow.state.stanza).to eq <<~STANZA.chomp
          1 bottle of beer on the wall, 1 bottle of beer.
          You take it down.
          You pass it around.
          No more bottles of beer on the wall.
        STANZA
      end
    end

    context "when one million" do
      let(:starting_bottles) { 1_000_000 }

      it_behaves_like "a successful flow"

      it "produces expected stanza" do
        expect(flow.state.stanza).to eq <<~STANZA.chomp
          1000000 bottles of beer on the wall, 1000000 bottles of beer.
          You take one down.
          You pass it around.
          999999 bottles of beer on the wall.
        STANZA
      end
    end
  end

  context "with number_to_take_down" do
    context "when invalid" do
      let(:number_to_take_down) { -1 }

      it "does not run" do
        expect { flow }.not_to change { RSpec::ExampleGroups::Flow::Bottle.count }
      end

      it "has expected status" do
        expect(flow).not_to be_state_valid
        expect(flow).to be_pending
        expect(flow).not_to be_triggered
        expect(flow).not_to be_success
        expect(flow).not_to be_failed
        expect(flow).not_to be_reverted
      end

      context "with trigger!" do
        subject(:trigger!) { RSpec::ExampleGroups::Flow::BottlesOnTheWallFlow.trigger!(**input) }

        it "raises" do
          expect { trigger! }.to raise_error Flow::Errors::StateInvalid
        end
      end
    end

    context "when none" do
      let(:number_to_take_down) { 0 }

      it_behaves_like "a successful flow"

      it "produces expected stanza" do
        expect(flow.state.stanza).to eq <<~STANZA.chomp
          99 bottles of beer on the wall, 99 bottles of beer.
          You took nothing down.
          You pass nothing around.
          99 bottles of beer on the wall.
        STANZA
      end
    end

    context "when many" do
      let(:number_to_take_down) { 3 }

      it_behaves_like "a successful flow"

      it "produces expected stanza" do
        expect(flow.state.stanza).to eq <<~STANZA.chomp
          99 bottles of beer on the wall, 99 bottles of beer.
          You take 3 down.
          You pass them around.
          96 bottles of beer on the wall.
        STANZA
      end
    end

    context "when one million" do
      let(:starting_bottles) { 1_000_000 }

      it_behaves_like "a successful flow"

      it "produces expected stanza" do
        expect(flow.state.stanza).to eq <<~STANZA.chomp
          1000000 bottles of beer on the wall, 1000000 bottles of beer.
          You take one down.
          You pass it around.
          999999 bottles of beer on the wall.
        STANZA
      end
    end
  end

  context "when number_to_take_down is greater than starting_bottles" do
    let(:starting_bottles) { 2 }
    let(:number_to_take_down) { 3 }

    it "raises" do
      expect { flow }.to raise_error ActiveRecord::RecordInvalid,
                                     "Validation failed: Number on the wall must be greater than or equal to 0"
    end
  end

  context "when the second operation fails by a known error" do
    let(:bottles) { RSpec::ExampleGroups::Flow::Bottle.create(of: bottles_of, number_on_the_wall: starting_bottles) }
    let(:starting_bottles) { 4 }
    let(:number_to_take_down) { 3 }

    before { bottles.update!(number_passed_around: 99) }

    it_behaves_like "a failed flow"

    it "has a failed operation" do
      expect(flow.failed_operation).to be_an_instance_of RSpec::ExampleGroups::Flow::PassBottlesAround
      expect(flow.failed_operation.operation_failure.problem).to eq :record_invalid
    end

    it "produces expected stanza" do
      expect(flow.state.stanza).to eq <<~STANZA.chomp
        4 bottles of beer on the wall, 4 bottles of beer.
        You take 3 down.
        Passing the bottles wasn't as sound, now there's 3 on the ground!
      STANZA
    end
  end

  context "when the second operation fails" do
    let(:number_to_take_down) { 5 }

    it_behaves_like "a failed flow"

    it "has a failed operation" do
      expect(flow.failed_operation).to be_an_instance_of RSpec::ExampleGroups::Flow::TakeBottlesDown
      expect(flow.failed_operation.operation_failure.problem).to eq :too_greedy
    end

    it "produces expected stanza" do
      expect(flow.state.stanza).to eq <<~STANZA.chomp
        99 bottles of beer on the wall, 99 bottles of beer.
        Something went wrong! It's the end of the song, and there's 99 bottles of beer on the wall.
      STANZA
    end
  end

  context "when the third operation fails" do
    let(:number_to_take_down) { 4 }

    it_behaves_like "a failed flow"

    it "has a failed operation" do
      expect(flow.failed_operation).to be_an_instance_of RSpec::ExampleGroups::Flow::PassBottlesAround
      expect(flow.failed_operation.operation_failure.problem).to eq :too_generous
    end

    it "produces expected stanza" do
      expect(flow.state.stanza).to eq <<~STANZA.chomp
        99 bottles of beer on the wall, 99 bottles of beer.
        You take 4 down.
      STANZA
    end
  end
end
