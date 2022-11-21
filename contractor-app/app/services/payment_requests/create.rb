# frozen_string_literal: true

module PaymentRequests
  class Create
    extend Dry::Initializer

    include AfterCommitEverywhere
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    param :payment_request_params, Types::Hash, reader: :private

    def call
      ActiveRecord::Base.transaction do
        payment_request = yield create_payment_request

        after_commit do
          Producers::PaymentRequests::Created.new(payment_request).call
        end
      end

      Success("Yay, maybe you'll get your money")
    end

    private

    def create_payment_request
      payment_request = PaymentRequest.new(payment_request_params)

      if payment_request.save
        Success(payment_request)
      else
        Failure(payment_request.errors.full_messages.join(', '))
      end
    end
  end
end
