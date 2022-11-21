# frozen_string_literal: true

describe PaymentRequests::Create do
  describe '#call' do
    subject { described_class.new(payment_request_params).call }

    context 'with proper params' do
      let(:payment_request_params) do
        {
          id: SecureRandom.uuid,
          amount_in_cents: 10000,
          currency: 'USD',
          description: 'New request'
        }
      end

      it 'returns Success monad' do
        expect(subject).to be_success
      end

      it 'creates a payment request with given attributes' do
        expect { subject }.to change(PaymentRequest, :count).by(1)
        expect(PaymentRequest.last).to have_attributes({
          amount_in_cents: 10000,
          currency: 'USD',
          description: 'New request'
        })
      end
    end

    context 'with invalid params' do
      let(:payment_request_params) do
        {
          id: SecureRandom.uuid,
          amount_in_cents: nil,
          currency: 'USD',
          description: 'New request'
        }
      end

      it 'returns Failure monad with validation errors' do
        expect(subject).to be_failure
        expect(subject.failure).to eq("Amount in cents can't be blank")
      end

      it 'does not create a payment request' do
        expect { subject }.not_to change(PaymentRequest, :count)
      end
    end
  end
end
