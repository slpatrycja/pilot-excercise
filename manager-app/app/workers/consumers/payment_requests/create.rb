# frozen_string_literal: true

module Consumers
  module PaymentRequests
    class Create
      include Sneakers::Worker

      from_queue 'payment_requests.created'

      ALLOWED_ATTRIBUTES = %w[id amount_in_cents currency description]

      def work(msg)
        data = ActiveSupport::JSON.decode(msg)
        attrs = data.slice(*ALLOWED_ATTRIBUTES)

        result = ::PaymentRequests::Create.new(attrs).call

        if result.success?
          ack!
        else
          create_log(false, data, message: e.message)
          reject!
        end
      rescue StandardError => e
        create_log(false, data, message: e.message)
        reject!
      end
    end
  end
end
