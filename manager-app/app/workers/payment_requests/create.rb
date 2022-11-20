# frozen_string_literal: true

module PaymentRequests
  class Create
    include Sneakers::Worker

    from_queue 'payment_requests.created'

    def work(msg)
      data = ActiveSupport::JSON.decode(msg)

      attrs = data.slice('id', 'amount_in_cents', 'currency', 'description')
      PaymentRequest.create!(attrs)

      ack!
    rescue StandardError => e
      create_log(false, data, message: e.message)
      reject!
    end
  end
end
