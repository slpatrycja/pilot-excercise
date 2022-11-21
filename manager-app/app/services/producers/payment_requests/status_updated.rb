# frozen_string_literal: true

module Producers
  module PaymentRequests
    class StatusUpdated < ::Producers::Base
      private

      def exchange_name
        'payment_requests'
      end

      def routing_key
        'payment_requests.status_updated'
      end
    end
  end
end
