# frozen_string_literal: true

class PaymentRequest < ApplicationRecord
  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  validates_presence_of :amount_in_cents, :currency

  def amount
    amount_in_cents / 100.00
  end
end
