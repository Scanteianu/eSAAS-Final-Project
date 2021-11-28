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
      user = User.find_by email_id: params[:username]
      if user == nil
        new_user = User.create(name: params[:name], email_id: params[:username])
        puts("new user created: "+ new_user.email_id)
      end
      puts "request received to set username: " + params[:username]
      render :json => {"setUsername"=>session[:username]}
    end
  end

  attr_accessor :currentCart
  def getCartFromDb(index)
    cartFromDb = FoodCart.find_by_id(index)
    cartToDisplay = Hash.new

    cartToDisplay[:cart_id] = cartFromDb[:id]
    cartToDisplay[:name] = cartFromDb[:name]
    cartToDisplay[:location] = cartFromDb[:location]
    cartToDisplay[:coordinates] = cartFromDb[:coordinates]
    cartToDisplay[:owner] = User.find_by_id(cartFromDb[:user_id])[:name] rescue "NA"
    cartToDisplay[:paymentOptions] = listifyPaymentOptions(cartFromDb[:payment_options])
    cartToDisplay[:topRatedFood]= cartFromDb[:top_rated_food]
    if cartFromDb.image.attached?
      cartToDisplay[:image] = cartFromDb.image.variant(resize: "320x320")
    end

    # Convert UTC time to eastern time
    parsed_open_time = Time.parse(cartFromDb[:opening_time].to_s())
    parsed_close_time = Time.parse(cartFromDb[:closing_time].to_s())
    cartToDisplay[:openHours] = parsed_open_time.in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p")
    cartToDisplay[:closeHours] = parsed_close_time.in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p")
    @currentCart=cartToDisplay

    # User must be logged in to write review
    session_username = getFromSessionObject(:username)
    @reviewEnabled = session_username != nil ? true : false

    # One review per user
    @hasUserWrittenReview = false

    # Get reviews
    reviewsToDisplay = Array.new
    fetchedReviews = FoodCart.get_all_reviews(index)
    for review in fetchedReviews
      currentUser = User.find_by_id(review[:user_id])
      if currentUser[:email_id] == session_username
        @hasUserWrittenReview = true
      end

      reviewHash = Hash.new
      reviewHash[:is_verified] = verify_user(currentUser[:email_id])
      reviewHash[:id] = review[:id]
      reviewHash[:cart_id] = cartFromDb[:id]
      reviewHash[:username] = currentUser[:name]
      reviewHash[:email_id] = currentUser[:email_id]
      reviewHash[:hasReadWriteAccess] = currentUser[:email_id] == session_username
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
    session_username = getFromSessionObject(:username)
    if session_username
      then
        user = User.find_by email_id: session_username
      else
        raise Exception.new "User must be logged in to edit their review"
      end
    
    review_hash[:user_id] = user.id
    review_hash[:food_cart_id] = params[:cart_id]
    review_hash[:rating] = initial_review_params[:rating]
    review_hash[:review] = initial_review_params[:review]
    created_review = User.create_review(review_hash[:user_id], review_hash[:food_cart_id], review_hash[:rating], review_hash[:review])

    # Remaining review attributes to display client-side
    review_hash[:id] = created_review[:id]
    review_hash[:username] = user[:name]
    review_hash[:email_id] = user[:email_id]
    review_hash[:hasReadWriteAccess] = user[:email_id] == session_username
    @review_to_display = review_hash

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.js
    end
  end

  def edit_review
    session_username = getFromSessionObject(:username)
    if session_username
      then
        user = User.find_by email_id: session_username
      else
        raise Exception.new "User must be logged in to edit their review"
      end
    review_to_update = Review.find_by_id(params[:id])
    review_to_update[:rating] = edit_review_params[:rating]
    review_to_update[:review] = edit_review_params[:review]
    review_to_update.save

    # Variable to be used in corresponding js.erb
    review_hash = Hash.new
    review_hash[:id] = review_to_update[:id]
    review_hash[:username] = user[:name]
    review_hash[:email_id] = user[:email_id]
    review_hash[:hasReadWriteAccess] = user[:email_id] == session_username
    review_hash[:rating] = edit_review_params[:rating]
    review_hash[:review] = edit_review_params[:review]
    @updated_review = review_hash

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.js
    end
  end

  def delete_review
    found_review = Review.find_by_id(params[:id])
    review_user = User.find_by_id(found_review[:user_id])
    begin
      if (getFromSessionObject(:username) and getFromSessionObject(:username) == review_user[:email_id])
        @deleted_review_id = params[:id]
        @deleted_review_cart = FoodCart.find_by_id(found_review[:food_cart_id])
        User.delete_review(params[:id])
      else
        raise Exception.new "Logged in user can only delete their own review"
      end
    rescue => exception
      puts exception
    end

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.js
    end
  end

  def new
    @all_payment_options = ['Cash','Card','Venmo']
    @all_weekdays = ['Sun', 'Mon', 'Tue', 'Wed', "Thu", 'Fri', 'Sat']
    # should render new.html.erb
  end

  def edit
    @cart = FoodCart.find_by_id(params[:id])
    @cart.opening_time = Time.parse(@cart.opening_time.to_s()).in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p")
    @cart.closing_time = Time.parse(@cart.closing_time.to_s()).in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M%p")
    @all_payment_options = ['Cash','Card','Venmo']
    @all_weekdays = ['Sun', 'Mon', 'Tue', 'Wed', "Thu", 'Fri', 'Sat']
    @accepted_payment_options = @cart.payment_options.split(", ")
    @open_on_days = []
    #if open days added to schema, uncomment below line
    # @open_on_days = @cart.open_on.split(", ")
  end


  def create
    # if session[:username] == nil
    #   flash[:notice] = "User must login to create a cart"
    #   redirect_to root_path
    #   return
    # end
    cart_to_create = cart_params.clone
    cart_to_create[:opening_time] = Time.parse(cart_params[:opening_time])
    cart_to_create[:closing_time] = Time.parse(cart_params[:closing_time])
    cart_to_create[:payment_options] = cart_params[:payment_options].keys.join(', ') rescue "NA"
    @cart = FoodCart.create!(cart_to_create)
    flash[:notice] = "#{@cart.name} was successfully created."
    redirect_to root_path
  end

  def update
    # if session[:username] == nil
    #   flash[:notice] = "User must login to edit a cart"
    #   redirect_to cart_path(params[:id])
    #   return
    # end
    cart_to_update = Hash.new
    cart_to_update[:name] = cart_params[:name]
    cart_to_update[:location] = cart_params[:location]
    cart_to_update[:coordinates] = cart_params[:coordinates]
    cart_to_update[:opening_time] = Time.parse(cart_params[:opening_time])
    cart_to_update[:closing_time] = Time.parse(cart_params[:closing_time])
    cart_to_update[:top_rated_food] = cart_params[:top_rated_food]
    cart_to_update[:payment_options] = cart_params[:payment_options].keys.join(', ') rescue "NA"
    if !cart_params[:image].nil?
      cart_to_update[:image] = cart_params[:image]
    end
    @cart = FoodCart.find params[:id]
    @cart.update_attributes!(cart_to_update)
    flash[:notice] = "#{@cart.name} was successfully updated."
    redirect_to cart_path(params[:id])
  end

  def listifyPaymentOptions(paymentOptStr)
    return paymentOptStr.split(", ")
  end
    
  def verify_user(user_email)
    #check if it has columbia.edu or barnard.edu
    if user_email.nil?
      return false
    else
      if user_email.include? "columbia.edu" or user_email.include? "barnard.edu"
        return true
      else
        return false
      end
    end
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def edit_review_params
    # params.require(:review).permit(:user_id, :cart_id, :rating, :review, :release_date)
    params.require(:edit_cart_review).permit(:review, :rating)
  end

  def initial_review_params
    params.require(:initial_cart_review).permit(:review, :rating)
  end

  def cart_params
    params.require(:cart).permit(:name, :location, :coordinates, :menu, :image, :opening_time, :closing_time, :top_rated_food, payment_options:{})
    # params.require(:cart).permit(:name, :location, :menu, :opening_time, :closing_time, :top_rated_food, payment_options:{}, open_days:{}, :coordinates)
  end
  
end
