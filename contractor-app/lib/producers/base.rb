# frozen_string_literal: true

module Producers
  class Base
    def initialize(payload)
      @payload = payload
    end

    def call
      connection.start

      channel = connection.create_channel
      exchange = channel.direct(exchange_name, durable: true)
      exchange.publish(payload.to_json, timestamp: Time.now.to_i, routing_key: routing_key)

      connection.close
    end

    private

    attr_reader :payload

    def exchange_name
      raise NotImplementedError
    end

    def routing_key
      raise NotImplementedError
    end

    def connection
      @connection ||= Bunny.new(
        hostname: ENV.fetch('RABBITMQ_HOST'),
        user: ENV.fetch('RABBITMQ_USER'),
        password: ENV.fetch('RABBITMQ_PASSWORD')
      )
    end
  end
end
