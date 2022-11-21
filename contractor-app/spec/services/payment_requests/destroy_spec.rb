# frozen_string_literal: true

describe PaymentRequests::Destroy do
  let!(:payment_request) { create(:payment_request) }

  describe '#call' do
    subject { described_class.new(payment_request_id).call }

    context 'with existing id' do
      let(:payment_request_id) { payment_request.id }

      context 'with no errors during deletion' do
        before do
          allow(Producers::PaymentRequests::Destroyed).to receive(:new).and_return(double(call: true))
        end

        it 'returns Success monad' do
          expect(subject).to be_success
        end

        it 'deletes the payment request' do
          expect { subject }.to change(PaymentRequest, :count).by(-1)
          expect { payment_request.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'sends message to RabbitMQ using a producer service' do
          expect(Producers::PaymentRequests::Destroyed).to receive(:new).with(instance_of(PaymentRequest))
            .and_return(double(call: true))

          subject
        end
      end

      context 'with error during deletion' do
        before do
          allow_any_instance_of(PaymentRequest).to receive(:destroy!).and_raise('Cannot destroy') # rubocop:disable RSpec/AnyInstance
        end

        it 'returns Failure monad with error' do
          expect(subject).to be_failure
          expect(subject.failure).to eq('Cannot destroy')
        end

        it 'does not delete the payment_request' do
          expect { subject }.not_to change(PaymentRequest, :count)
        end
      end
    end

    context 'with non existing id' do
      let(:payment_request_id) { SecureRandom.uuid }

      it 'returns Failure monad with error' do
        expect(subject).to be_failure
        expect(subject.failure).to eq('Oops, payment request not found')
      end
    end
  end
end
