
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

  describe 'GET #new' do
    subject { get :new }

    it 'renders proper view' do
      subject

      expect(response).to render_template :new
      expect(assigns(:payment_request)).to be_a(PaymentRequest)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { payment_request: payment_request_params } }

    let(:payment_request_params) do
      {
        'amount_in_cents' => '10000',
        'currency' => 'USD',
        'description' => 'New request'
      }
    end

    before do
      allow(Producers::PaymentRequests::Created).to receive(:new).and_return(double(call: true))
    end

    it 'calls proper service' do
      expect(PaymentRequests::Create).to receive(:new).with(payment_request_params).and_call_original

      subject
    end

    it 'redirects to list of all payment requests with a success message' do
      expect(subject).to redirect_to(payment_requests_path)
      expect(flash[:notice]).to eq("Yay, maybe you'll get your money")
    end

    it 'creates a payment request' do
      expect { subject }.to change(PaymentRequest, :count).by(1)
    end

    it 'sends message to RabbitMQ using a producer service' do
      expect(Producers::PaymentRequests::Created).to receive(:new).with(instance_of(PaymentRequest))
        .and_return(double(call: true))

      subject
    end

    context 'with invalid params' do
      let(:payment_request_params) do
        super().merge('amount_in_cents' => nil)
      end

      it 'renders list of all payment requests with a flash alert' do
        subject

        expect(subject).to redirect_to(payment_requests_path)
        expect(flash[:alert]).to eq("Amount in cents can't be blank")
      end

      it 'does not create a payment request' do
        expect { subject }.not_to change(PaymentRequest, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: payment_request_id } }

    let!(:payment_request) { create(:payment_request) }

    context 'with existing id' do
      let(:payment_request_id) { payment_request.id }

      it 'calls proper service' do
        expect(PaymentRequests::Destroy).to receive(:new).with(payment_request_id.to_s)
          .and_call_original

        subject
      end

      it 'redirects to list of all payment requests with a success message' do
        expect(subject).to redirect_to(payment_requests_path)
        expect(flash[:notice]).to eq('Request deleted')
      end

      it 'destroys the payment_request' do
        expect { subject }.to change(PaymentRequest, :count).by(-1)
      end
    end

    context 'when payment request not found' do
      let(:payment_request_id) { 1234 }

      it 'renders list of all payment requests with a flash alert' do
        expect(subject).to redirect_to(payment_requests_path)
        expect(flash[:alert]).to eq('Oops, payment request not found')
      end

      it 'does not destroy a payment request' do
        expect { subject }.not_to change(PaymentRequest, :count)
      end
    end
  end
end
