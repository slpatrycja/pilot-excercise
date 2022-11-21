# frozen_string_literal: true

module Producers
  module PaymentRequests
    class Updated < ::Producers::Base
      private

      def exchange_name
        'payment_requests_reviews'
      end

      def routing_key
        'payment_requests_reviews.updated'
      end
    end
  end
end
