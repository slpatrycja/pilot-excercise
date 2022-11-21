# frozen_string_literal: true

module Producers
  module PaymentRequests
    class Destroyed < ::Producers::Base
      private

      def exchange_name
        'payment_requests'
      end

      def routing_key
        'payment_requests.destroyed'
      end
    end
  end
end
