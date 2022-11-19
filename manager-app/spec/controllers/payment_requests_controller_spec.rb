# frozen_string_literal: true

describe PaymentRequestsController do
  render_views

  describe 'GET #index' do
    subject { get :index }

    let!(:payment_request1) { create(:payment_request) }
    let!(:payment_request2) { create(:payment_request) }

    it 'renders proper view' do
      subject

      expect(response).to render_template :index
      expect(assigns(:payment_requests)).to match_array([payment_request1, payment_request2])
    end
  end

  describe 'PATCH #update' do
    subject { patch :update, params: { id: payment_request_id, payment_request: payment_request_params } }

    let(:payment_request_params) { { 'status' => 'accepted' } }
    let!(:payment_request) { create(:payment_request) }

    context 'with existing id' do
      let(:payment_request_id) { payment_request.id }

      it 'calls proper service' do
        expect(PaymentRequests::Update).to receive(:new).with(payment_request_id.to_s, payment_request_params)
          .and_call_original

        subject
      end

      it 'updates payment request status' do
        expect { subject }.to change { payment_request.reload.status }.from('pending').to('accepted')
      end

      it 'redirects to list of all payment requests with a success message' do
        expect(subject).to redirect_to(payment_requests_path)
        expect(flash[:notice]).to eq('Payment request has been successfully updated')
      end

      context 'when payment request is no longer pending' do
        let!(:payment_request) { create(:payment_request, status: :rejected) }

        it 'renders list of all payment requests with a flash alert' do
          expect(subject).to redirect_to(payment_requests_path)
          expect(flash[:alert]).to eq('Cannot update payment request which is not pending')
        end

        it 'does not update payment request status' do
          expect { subject }.not_to change { payment_request.reload.status }
        end
      end

      context 'with params other than the status' do
        let(:payment_request_params) { { 'amount_in_cents' => 9999 } }

        it 'does not update this attribute of the payment request' do
          expect { subject }.not_to change { payment_request.reload.amount_in_cents }
        end

        it 'renders list of all payment requests' do
          subject

          expect(subject).to redirect_to(payment_requests_path)
        end
      end
    end

    context 'when payment was request not found' do
      let(:payment_request_id) { 1234 }

      it 'renders list of all payment requests with a flash alert' do
        expect(subject).to redirect_to(payment_requests_path)
        expect(flash[:alert]).to eq('Oops, payment request not found')
      end
    end
  end
end
