# frozen_string_literal: true

module PaymentRequests
  class UpdateStatus
    include Sneakers::Worker

    from_queue 'payment_requests.status_updated'

    def work(msg)
      data = ActiveSupport::JSON.decode(msg)

      attrs = data.slice('id', 'status')
      PaymentRequest.find(attrs.fetch('id')).update!(status: attrs.fetch('status'))

      ack!
    rescue StandardError => e
      create_log(false, data, message: e.message)
      reject!
    end
  end
end
