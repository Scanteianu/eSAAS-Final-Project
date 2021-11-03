class CartsController < ApplicationController

  def index
    @carts = FoodCart.all
  end


  def cart
    getCartFromDb(params[:id])
  end
  def getCartFromDb(index)
    cartFromDb = FoodCart.find_by_id(index)
    cartToDisplay = Hash.new

    cartToDisplay[:name] = cartFromDb.name
    cartToDisplay[:location] = cartFromDb.location
    cartToDisplay[:owner] = User.find_by_id(cartFromDb.user_id).name
    cartToDisplay[:paymentOptions] = listifyPaymentOptions(cartFromDb.payment_options)
    cartToDisplay[:topRatedFood]= cartFromDb.top_rated_food

    # Convert UTC time to eastern time
    parsed_open_time = Time.parse(cartFromDb.opening_time.to_s())
    parsed_close_time = Time.parse(cartFromDb.closing_time.to_s())
    cartToDisplay[:openHours] = parsed_open_time.in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p")
    cartToDisplay[:closeHours] = parsed_close_time.in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p")
    @currentCart=cartToDisplay

    # Get reviews
    reviewsToDisplay = Array.new
    fetchedReviews = Review.where(:food_cart_id => index)
    for review in fetchedReviews
      reviewHash = Hash.new
      reviewHash[:username] = User.find_by_id(review.user_id).name
      reviewHash[:rating] = review.rating
      reviewHash[:review] = review.review
      reviewHash[:createdAt] = review.created_at
      reviewHash[:updatedAt] = review.updated_at
      reviewsToDisplay.push(reviewHash)
    end
    @currentReviews = reviewsToDisplay

  end
  def initialize_sample
    #(By Ankita): delete this controller file/rename this file to FoodCartController to make it consistent with db
    #(dan): let's leave the name, it should be ok to have the inconsistency, and we'd have to update things like
    #the routes
    aSampleCart= Hash.new
    aSampleCart[:name]="The Chicken Dudes"
    aSampleCart[:location]="some-google-token-or-other-stringified-thing"
    aSampleCart[:paymentOptions]=["Venmo","Cash"]
    aSampleCart[:reviews]=[{:user=>"DanScan", :star_rating=>3, :text=>"food was meh"}]




  end

  def add_review
    review_hash = Hash.new
    review_hash[:user_id] = 1
    review_hash[:food_cart_id] = params[:id]
    review_hash[:rating] = review_params[:rating]
    review_hash[:review] = review_params[:review]
    @review = Review.create!(review_hash)
    redirect_to cart_path(@review.food_cart_id)
  end

  def listifyPaymentOptions(paymentOptStr)
    return paymentOptStr.split(", ")
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def review_params
    # params.require(:review).permit(:user_id, :cart_id, :rating, :review, :release_date)
    params.require(:cart_review).permit(:review, :rating)
  end
end
