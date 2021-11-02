class CartsController < ApplicationController

  def index
    #renders index Template
    initialize_sample
  end
  def initialize_sample
    #(By Ankita): delete this controller file/rename this file to FoodCartController to make it consistent with db
    aSampleCart= Hash.new
    aSampleCart[:name]="The Chicken Dudes"
    aSampleCart[:location]="some-google-token-or-other-stringified-thing"
    aSampleCart[:paymentOptions]=["Venmo","Cash"]
    aSampleCart[:reviews]=[{:user=>"DanScan", :star_rating=>3, :text=>"food was meh"}]
    @currentCart=aSampleCart


  end
end
