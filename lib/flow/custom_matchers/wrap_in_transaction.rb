# frozen_string_literal: true

# RSpec matcher that tests usage of `.wrap_in_transaction` for `ApplicationFlow` or `ApplicationOperation`
#
#     class ExampleFlow
#       wrap_in_transaction
#       operations OperationOne, OperationTwo
#     end
#
#     class ExampleState
#       wrap_in_transaction except: :undo
#     end
#
#     RSpec.describe ExampleFlow, type: :flow do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to wrap_in_transaction }
#     end
#
#     RSpec.describe ExampleState, type: :state do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to wrap_in_transaction(except: :undo) }
#     end

RSpec::Matchers.define :wrap_in_transaction do |only: nil, except: nil|
  match do |instance|
    all_methods = instance.class.callbacks_for_transaction
    expected_to_be_wrapped = callbacks_to_wrap(instance, only: only, except: except)
    expected_not_to_be_wrapped = all_methods - expected_to_be_wrapped
    original_transaction_count = instance.class.transaction_provider.connection.open_transactions

    expected_to_be_wrapped.each do |method|
      allow(instance).to receive(method) do
        expect(instance.class.transaction_provider.connection.open_transactions).to eq original_transaction_count + 1
      end
    end

    expected_not_to_be_wrapped.each do |method|
      allow(instance).to receive(method) do
        expect(instance.class.transaction_provider.connection.open_transactions).to eq original_transaction_count
      end
    end

    all_methods.each do |method|
      instance.run_callbacks(method) { instance.public_send(method) }
      expect(instance).to have_received(method)
    end
  end

  description do |instance|
    "wrap #{pretty_callbacks(callbacks_to_wrap(instance, only: only, except: except))} in a transaction"
  end

  failure_message do |instance|
    pretty_callbacks_to_wrap = pretty_callbacks(callbacks_to_wrap(instance, only: only, except: except))
    "expected #{instance.class.name} to wrap #{pretty_callbacks_to_wrap} in a transaction"
  end

  def callbacks_to_wrap(instance, only:, except:)
    instance.class.__send__(:callbacks_to_wrap, only: only, except: except)
  end

  def pretty_callbacks(callbacks)
    callbacks.join(", ")
  end
end
