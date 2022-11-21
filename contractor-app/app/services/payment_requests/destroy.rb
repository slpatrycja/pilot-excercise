# frozen_string_literal: true

module PaymentRequests
  class Destroy
    extend Dry::Initializer

    include AfterCommitEverywhere
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    param :id, Types::String, reader: :private

    def call
      ActiveRecord::Base.transaction do
        payment_request = yield PaymentRequests::Find.new(id).call
        yield delete_payment_request(payment_request)

        after_commit do
          Producers::PaymentRequests::Destroyed.new(payment_request).call
        end
      end

      Success('Request deleted')
    end

    private

    def delete_payment_request(payment_request)
      result = Try { payment_request.destroy! }

      if result.error?
        Failure(result.exception.message)
      else
        Success('Request deleted')
      end
    end
  end
end
