# frozen_string_literal: true

module Producers
  module PaymentRequests
    class Created < ::Producers::Base
      private

      def exchange_name
        'payment_requests'
      end

      def routing_key
        'payment_requests.created'
      end
    end
  end
end
