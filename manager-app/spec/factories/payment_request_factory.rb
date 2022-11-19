# frozen_string_literal: true

FactoryBot.define do
  factory :payment_request do
    amount_in_cents { 10_000 }
    currency { 'USD' }
    description { 'Pls accept, I need money' }
  end
end
