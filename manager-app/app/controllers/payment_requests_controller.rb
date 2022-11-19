# frozen_string_literal: true

class PaymentRequestsController < ApplicationController
  def index
    @payment_requests = PaymentRequest.all
  end

  def update
    result = ::PaymentRequests::Update.new(params.require(:id), payment_request_params.to_h).call

    if result.success?
      flash[:notice] = result.success
    else
      flash[:alert] = result.failure
    end

    redirect_to payment_requests_path
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:status)
  end
end
