# frozen_string_literal: true

module PaymentRequests
  class Destroy
    extend Dry::Initializer

    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    param :id, Types::Coercible::Integer, reader: :private

    def call
      payment_request = yield PaymentRequests::Find.new(id).call
      result = Try { payment_request.destroy! }

      if result.error?
        Failure(result.exception.message)
      else
        Success('Request deleted')
      end
    end
  end
end
