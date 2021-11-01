module Api
  class CartsController < ApplicationController
  
    def index
      #renders index Template
      initialize_sample
    end
    def initialize_sample
      aSampleCart= Hash.new
      aSampleCart[:name]="The Chicken Dudes"
      aSampleCart[:location]="some-google-token-or-other-stringified-thing"
      aSampleCart[:paymentOptions]=["Venmo","Cash"]
      aSampleCart[:reviews]=[{:user=>"DanScan", :star_rating=>3, :text=>"food was meh"}]
      @currentCart=aSampleCart
  
      render json: @currentCart, status: 200
    end
  end
end
