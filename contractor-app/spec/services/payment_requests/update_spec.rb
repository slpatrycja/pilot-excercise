# frozen_string_literal: true

describe PaymentRequests::Update do
  let!(:payment_request) { create(:payment_request) }

  describe '#call' do
    subject { described_class.new(payment_request_id, payment_request_params).call }

    let(:payment_request_params) { { status: :accepted } }

    context 'with existing id' do
      let(:payment_request_id) { payment_request.id }

      describe 'updating the status' do
        context 'when payment request is pending' do
          it 'returns Success monad' do
            expect(subject).to be_success
          end

          it 'updates payment request status' do
            expect { subject }.to change { payment_request.reload.status }.from('pending').to('accepted')
          end
        end

        context 'when payment is either accepted or rejected' do
          let!(:payment_request) { create(:payment_request, status: :rejected) }

          it 'returns Failure monad with error message' do
            expect(subject).to be_failure
            expect(subject.failure).to eq('Cannot update payment request which is not pending')
          end

          it 'does not update payment request status' do
            expect { subject }.not_to change { payment_request.reload.status }
          end
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
