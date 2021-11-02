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
    cartToDisplay[:hours]= [cartFromDb.opening_time,cartFromDb.closing_time]
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
    redirect_to carts_path
  end

  def listifyPaymentOptions(paymentOptStr)
    return paymentOptStr.split(", ")
  end
end
