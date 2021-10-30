class User < ActiveRecord::Base
    has_many :food_carts
    has_many :reviews
end
