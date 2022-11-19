# frozen_string_literal: true

class PaymentRequestsController < ApplicationController
  def index
    @payment_requests = PaymentRequest.all
  end

  def new
    @payment_request = PaymentRequest.new
  end

  def create
    PaymentRequest.create!(payment_request_params)

    redirect_to payment_requests_path
  end

  def destroy
    PaymentRequest.find(params.require(:id)).destroy!

    redirect_to payment_requests_path
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:amount_in_cents, :currency, :description)
  end
end
