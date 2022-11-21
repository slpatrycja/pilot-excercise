# frozen_string_literal: true

describe Consumers::PaymentRequests::Create do
  describe '#work' do
    subject { instance.work(payload.to_json) }

    let(:instance) { described_class.new }
    let(:payload) do
      {
        'id' => SecureRandom.uuid,
        'amount_in_cents' => 10_000,
        'currency' => 'USD'
      }
    end

    before do
      allow(PaymentRequests::Create).to receive(:new).and_return(
        instance_double(PaymentRequests::Create, call: result)
      )
    end

    context 'when payment request has been successfully updated' do
      let(:result) { Dry::Monads::Success() }

      it 'calls service with proper params' do
        expect(PaymentRequests::Create).to receive(:new).with(payload)

        subject
      end

      it 'acknowledges the event' do
        expect(instance).to receive(:ack!)

        subject
      end
    end

    context 'when payment request has not been successfully updated' do
      let(:result) { Dry::Monads::Failure() }

      it 'calls service with proper params' do
        expect(PaymentRequests::Create).to receive(:new).with(payload)

        subject
      end

      it 'rejects the event' do
        expect(instance).to receive(:reject!)

        subject
      end
    end
  end
end
