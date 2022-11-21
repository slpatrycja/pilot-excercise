# frozen_string_literal: true

describe Consumers::PaymentRequests::Destroy do
  describe '#work' do
    subject { instance.work(payload.to_json) }

    let(:instance) { described_class.new }
    let(:payload) do
      {
        'id' => SecureRandom.uuid
      }
    end

    before do
      allow(PaymentRequests::Destroy).to receive(:new).and_return(
        instance_double(PaymentRequests::Destroy, call: result)
      )
    end

    context 'when payment request has been successfully updated' do
      let(:result) { Dry::Monads::Success() }

      it 'calls service with proper params' do
        expect(PaymentRequests::Destroy).to receive(:new).with(payload['id'])

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
        expect(PaymentRequests::Destroy).to receive(:new).with(payload['id'])

        subject
      end

      it 'rejects the event' do
        expect(instance).to receive(:reject!)

        subject
      end
    end
  end
end
