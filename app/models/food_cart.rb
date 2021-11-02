class FoodCart < ActiveRecord::Base
    belongs_to :user
    has_many :reviews, dependent: :destroy
    @allowed_payment_options = ["cash", "card", "venmo"]

    def self.get_all_reviews(food_cart_id)
        food_cart = FoodCart.find(food_cart_id)
        food_cart.reviews
    end
end
