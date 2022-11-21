# frozen_string_literal: true

module Consumers
  module PaymentRequests
    class Destroy
      include Sneakers::Worker

      from_queue 'payment_requests.destroyed'

      ID_ATTRIBUTE = 'id'

      def work(msg)
        data = ActiveSupport::JSON.decode(msg)
        id = data.fetch(ID_ATTRIBUTE)

        result = ::PaymentRequests::Destroy.new(id).call

        result.success? ? ack! : reject!
      rescue StandardError => e
        reject!
      end
    end
  end
end
