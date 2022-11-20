# frozen_string_literal: true

module PaymentRequests
  class Find
    extend Dry::Initializer

    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    param :id, Types::String, reader: :private

    def call
      payment_request = PaymentRequest.find_by(id: id)

      if payment_request.present?
        Success(payment_request)
      else
        Failure('Oops, payment request not found')
      end
    end
  end
end
