class CartsController < ApplicationController

  def index
    cartsArray = Array.new
    foodCarts = FoodCart.all
    for foodCart in foodCarts
      foodCartHash = Hash.new
      foodCartHash[:id] = foodCart[:id]
      foodCartHash[:name] = foodCart[:name]
      foodCartHash[:location] = foodCart[:location]
      foodCartHash[:opening_time] = Time.parse(foodCart[:opening_time].to_s()).in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p") rescue nil
      foodCartHash[:closing_time] = Time.parse(foodCart[:closing_time].to_s()).in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p") rescue nil
      foodCartHash[:payment_options] = foodCart[:payment_options]
      foodCartHash[:top_rated_food] = foodCart[:top_rated_food]
      foodCartHash[:coordinates] = foodCart[:coordinates]
      cartsArray.push(foodCartHash)
    end
    @carts = cartsArray
  end


  def cart
    getCartFromDb(params[:id])
  end

  def setusername
    if params[:username]=="Nil"
      then
      session[:username]=nil
      puts "user logged out: " + params[:username]
      render :json => {"setUsername"=>session[:username]}
    else
      session[:username]=params[:username]
      puts "request received to set username: " + params[:username]
      render :json => {"setUsername"=>session[:username]}
    end

  end

  attr_accessor :currentCart
  def getCartFromDb(index)
    cartFromDb = FoodCart.find_by_id(index)
    cartToDisplay = Hash.new

    cartToDisplay[:name] = cartFromDb[:name]
    cartToDisplay[:location] = cartFromDb[:location]
    cartToDisplay[:coordinates] = cartFromDb[:coordinates]
    cartToDisplay[:owner] = User.find_by_id(cartFromDb[:user_id])[:name]
    cartToDisplay[:paymentOptions] = listifyPaymentOptions(cartFromDb[:payment_options])
    cartToDisplay[:topRatedFood]= cartFromDb[:top_rated_food]

    # Convert UTC time to eastern time
    parsed_open_time = Time.parse(cartFromDb[:opening_time].to_s())
    parsed_close_time = Time.parse(cartFromDb[:closing_time].to_s())
    cartToDisplay[:openHours] = parsed_open_time.in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p")
    cartToDisplay[:closeHours] = parsed_close_time.in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p")
    @currentCart=cartToDisplay

    # Get reviews
    reviewsToDisplay = Array.new
    fetchedReviews = FoodCart.get_all_reviews(index)
    for review in fetchedReviews
      reviewHash = Hash.new
      reviewHash[:username] = User.find_by_id(review[:user_id])[:name]
      reviewHash[:rating] = review[:rating]
      reviewHash[:review] = review[:review]
      reviewHash[:createdAt] = review[:created_at]
      reviewHash[:updatedAt] = review[:updated_at]
      reviewsToDisplay.push(reviewHash)
    end
    @currentReviews = reviewsToDisplay

  end

  def add_review
    review_hash = Hash.new
    review_hash[:user_id] = 1
    review_hash[:food_cart_id] = params[:id]
    review_hash[:rating] = review_params[:rating]
    review_hash[:review] = review_params[:review]
    @review = Review.create!(review_hash)
    redirect_to cart_path(@review[:food_cart_id])
  end

  def new
    @all_payment_options = ['Cash','Card','Venmo']
    @all_weekdays = ['Sun', 'Mon', 'Tue', 'Wed', "Thu", 'Fri', 'Sat']
    # should render new.html.erb
  end


  def create
    if session[:username] == nil
      flash[:notice] = "User must login to create a cart"
      redirect_to root_path
      return
    end
    cartToCreate = Hash.new
    cartToCreate[:name] = cart_params[:name]
    cartToCreate[:location] = cart_params[:location]
    cartToCreate[:opening_time] = cart_params[:opening_time]
    cartToCreate[:closing_time] = cart_params[:closing_time]
    cartToCreate[:payment_options] = cart_params[:payment_options].keys.join(', ')
    # puts(cartToCreate)
    @cart = FoodCart.create!(cartToCreate)
    flash[:notice] = "#{@cart.name} was successfully created."
    redirect_to root_path
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

  def cart_params
    params.require(:cart).permit(:name, :location, :menu, :opening_time, :closing_time, payment_options:{})
    # params.require(:cart).permit(:name, :location, :menu, :opening_time, :closing_time, payment_options:{}, open_days:{})
  end
end
