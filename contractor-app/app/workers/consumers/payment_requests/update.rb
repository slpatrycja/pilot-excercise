# frozen_string_literal: true

module Consumers
  module PaymentRequests
    class Update
      include Sneakers::Worker

      from_queue 'payment_requests_reviews.updated'

      ALLOWED_ATTRIBUTES = %w[id status].freeze

      def work(msg)
        data = ActiveSupport::JSON.decode(msg)
        attrs = data.slice(*ALLOWED_ATTRIBUTES)

        result = ::PaymentRequests::Update.new(attrs.fetch('id'), attrs).call

        result.success? ? ack! : reject!
      rescue StandardError
        reject!
      end
    end
  end
end
