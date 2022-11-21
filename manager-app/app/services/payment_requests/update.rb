# frozen_string_literal: true

module PaymentRequests
  class Update
    extend Dry::Initializer

    include AfterCommitEverywhere
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    param :id, Types::String, reader: :private
    param :payment_request_params, Types::Hash, reader: :private

    def call
      ActiveRecord::Base.transaction do
        payment_request = yield PaymentRequests::Find.new(id).call
        yield update_payment_request(payment_request)

        after_commit do
          Producers::PaymentRequests::Updated.new(payment_request).call
        end
      end

      Success('Payment request has been successfully updated')
    end

    private

    def update_payment_request(payment_request)
      return Failure('Cannot update payment request which is not pending') unless payment_request.pending?

      if payment_request.update(payment_request_params)
        Success()
      else
        Failure(payment_request.errors.full_messages)
      end
    end
  end
end
