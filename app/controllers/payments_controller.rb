class PaymentsController < ApplicationController
  def success
  end

  def webhook
    payment_id = params[:data][:object][:payment_intent]
    payment = Stripe::PaymentIntent.retrieve(payment_id)
    event_id = payment.metadata.listing_id
    
  end
end
