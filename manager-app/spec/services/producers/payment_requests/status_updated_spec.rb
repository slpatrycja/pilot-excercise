# frozen_string_literal: true

describe Producers::PaymentRequests::StatusUpdated do
  let(:bunny_double) do
    instance_double(Bunny::Session, start: true, close: true, create_channel: channel_double)
  end
  let(:channel_double) do
    instance_double(Bunny::Channel, direct: exchange_double)
  end
  let(:exchange_double) do
    instance_double(Bunny::Exchange, publish: true)
  end

  describe '#call' do
    subject { described_class.new(payload).call }

    before do
      allow(Bunny).to receive(:new).and_return(bunny_double)
    end

    let(:payload) { { message: 'Very cool message' } }

    it 'creates exchange with a specified name' do
      expect(channel_double).to receive(:direct).with('payment_requests', durable: true)

      subject
    end

    it 'publishes payload to specified exchange' do
      expect(exchange_double).to receive(:publish).with(
        payload.to_json,
        timestamp: instance_of(Integer),
        routing_key: 'payment_requests.status_updated'
      )

      subject
    end
  end
end
