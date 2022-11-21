# frozen_string_literal: true

describe PaymentRequests::Find do
  let!(:payment_request) { create(:payment_request) }

  describe '#call' do
    subject { described_class.new(payment_request_id).call }

    context 'with existing id' do
      let(:payment_request_id) { payment_request.id }

      it 'returns Success monad with a payment request object' do
        expect(subject).to be_success
        expect(subject.success).to eq(payment_request)
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
