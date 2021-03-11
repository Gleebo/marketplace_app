class ListingsController < ApplicationController
  before_action :set_listing, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:new]
  # GET /listings or /listings.json
  def index
    @listings = Listing.all
  end

  # GET /listings/1 or /listings/1.json
  def show
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: current_user.email,
      line_items: [{
        name: @listing.title,
        description: @listing.description,
        amount: @listing.price,
        currency: 'aud',
        quantity: 1,
      }],
      payment_intent_data: {
        metadata: {
          listing_id: @listing_id
        }
      },
      success_url: "#{root_url}payments/success?listingId=#{@listing.id}",
      cancel_url: root_url
    )
    @session_id = session.id
  end

  def user_listings
  end
  # GET /listings/new
  def new
    @listing = Listing.new
    @categories = Category.all
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings or /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user
    @listing.category = Category.find(params[:listing][:category])
    @listing.photo.attach params[:listing][:photo]
    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: "Listing was successfully created." }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1 or /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1 or /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: "Listing was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def search
    title     = "%#{params[:search]}%"
    category  = params[:category]
    min_price = params[:min_price].to_i * 100
    max_price = params[:max_price].to_i * 100
    order     = params[:order]
    
    query = Listing.all
    query = query.where("title like ?", title) if title != ""
    query = query.where("category_id = ?", category) if category != ""
    query = query.where("price >= ?", min_price) if min_price > 0
    query = query.where("price <= ?", max_price) if max_price > 0
    query = query.order(price: :desc) if order == "asc"
    query = query.order(price: :asc) if order == "desc"
    @search_results = query
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:title, :description, :price)
    end
end
