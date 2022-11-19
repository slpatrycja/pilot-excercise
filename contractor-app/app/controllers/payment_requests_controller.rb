# frozen_string_literal: true

class PaymentRequestsController < ApplicationController
  def index
    @payment_requests = PaymentRequest.all
  end

  def new
    @payment_request = PaymentRequest.new
  end

  def create
    result = ::PaymentRequests::Create.new(payment_request_params.to_h).call

    if result.success?
      flash[:notice] = result.success
    else
      flash[:alert] = result.failure
    end

    redirect_to payment_requests_path
  end

  def destroy
    result = ::PaymentRequests::Destroy.new(params.require(:id)).call

    if result.success?
      flash[:notice] = result.success
    else
      flash[:alert] = result.failure
    end

    redirect_to payment_requests_path
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:amount_in_cents, :currency, :description)
  end
end
