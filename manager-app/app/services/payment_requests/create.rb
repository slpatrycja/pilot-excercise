# frozen_string_literal: true

module PaymentRequests
  class Create
    extend Dry::Initializer

    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    param :payment_request_params, Types::Hash, reader: :private

    def call
      payment_request = PaymentRequest.new(payment_request_params)

      if payment_request.save
        Success()
      else
        Failure(payment_request.errors.full_messages.join(', '))
      end
    end
  end
end
