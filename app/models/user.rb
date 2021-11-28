class User < ActiveRecord::Base
    has_many :food_carts
    has_many :reviews

    def self.create_review(user_id, food_cart_id, rating, review_string)
        #TODO for ankita: implement argument sanity check
        Review.create(:user_id => user_id, :food_cart_id => food_cart_id, 
            :rating => rating, :review => review_string)
    end

    def self.delete_review(review_id)
        if review_id
            Review.find(review_id).destroy
        end
    end
end
