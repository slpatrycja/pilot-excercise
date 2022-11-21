# frozen_string_literal: true

module PaymentRequests
  class Update
    extend Dry::Initializer

    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    param :id, Types::String, reader: :private
    param :payment_request_params, Types::Hash, reader: :private

    def call
      payment_request = yield PaymentRequests::Find.new(id).call

      update_payment_request(payment_request)
    end

    private

    def update_payment_request(payment_request)
      return Failure('Cannot update payment request which is not pending') unless payment_request.pending?

      payment_request.assign_attributes(payment_request_params)

      if payment_request.save
        Success()
      else
        Failure(payment_request.errors.full_messages)
      end
    end
  end
end
