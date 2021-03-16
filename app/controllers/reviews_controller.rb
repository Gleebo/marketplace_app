class ReviewsController < ApplicationController
  before_action :set_reviewee, only: [:new]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new({rating: review_params[:rating].to_i, content: review_params[:content]})
    @review.reviewer = current_user
    @review.reviewee = User.find(review_params[:reviewee])
    @review.save
    #redirect_to purchases_path
  end

  private
  def set_reviewee
    @reviewee = User.find(params[:id])
  end
  
  def review_params
    params.require(:review).permit(:rating, :content, :reviewee)
  end
end
