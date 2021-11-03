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
  end

  def add_review
    redirect_to carts_path
  end

  def listifyPaymentOptions(paymentOptStr)
    return paymentOptStr.split(", ")
  end
end
