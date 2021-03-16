class ListingsController < ApplicationController
  before_action :set_listing, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:new]

  def index
    @listings = Listing.all.limit 20
  end

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
          listing_id: @listing.id,
          user_id: current_user.id
        }
      },
      success_url: "#{root_url}payments/success?listingId=#{@listing.id}",
      cancel_url: root_url
    )
    @session_id = session.id
  end

  def user_listings
  end

  def show_purchases
    @purchases = current_user.purchases.all
    @reviewees = current_user.written_reviews.all.map { |r| r.reviewee.id }
  end

  # GET /listings/new
  def new
    # Create a new listing
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings or /listings.json
  def create
    fields = listing_params
    # new listings
    @listing = Listing.new({title: fields[:title], description: fields[:description], price: fields[:price]})
    @listing.user = current_user
    @listing.category = Category.find(fields[:category])
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
    # Update the listing
    fields = listing_params
    @listing.category = Category.find(fields[:category])
    @listing.photo.attach params[:listing][:photo]
    respond_to do |format|
      if @listing.update({title: fields[:title], description: fields[:description], price: fields[:price]})
        format.html { redirect_to @listing, notice: "Listing was successfully updated." }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # Delete listing
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
    
    # get all listings
    query = Listing.all

    # get all listings that are not sold
    query = query.where(sold: false)
    
    # search by title if title is provided
    query = query.where("title like ?", title) if title != ""
    
    # query search by category if category is provided
    query = query.where("category_id = ?", category) if category != ""
    
    # query limit by minimum price if minum price is provided
    query = query.where("price >= ?", min_price) if min_price > 0
    
    # query limit by maximum price if maximum price is provided
    query = query.where("price <= ?", max_price) if max_price > 0
    
    # query order listings in ascending order of the price of order value is asc
    query = query.order(price: :desc) if order == "asc"
    
    # query order listings in descending order of the price of order value is desc
    query = query.order(price: :asc) if order == "desc"
    
    # execute query and save results in an instace property
    @search_results = query.limit 20
  end

  private
    def set_listing
      # Find lisitng by id
      @listing = Listing.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:title, :description, :price, :category)
    end
end
