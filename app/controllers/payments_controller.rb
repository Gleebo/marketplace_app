class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def success
  end

  def webhook
    payment_id = params[:data][:object][:payment_intent]
    payment = Stripe::PaymentIntent.retrieve(payment_id)

    # get listing that was sold
    listing = Listing.find(payment.metadata.listing_id)

    # get user who bought the listing
    user = User.find(payment.metadata.user_id)

    # create a purchase to update user's purchase history
    Purchase.create(user: user, listing: listing)

    # Set listing to sold
    listing.sold = true
    listing.save
  end

end
