class Review < ActiveRecord::Base
    belongs_to :food_cart
    belongs_to :user
end
