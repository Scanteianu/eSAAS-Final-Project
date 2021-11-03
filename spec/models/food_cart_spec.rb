require 'rails_helper'

RSpec.describe FoodCart, type: :model do
  describe 'get_all_reviews' do
    it 'gets all reviews for specified food cart id successfully' do
      # GIVEN
      review = Review.create(:user_id => 1, :food_cart_id => 3, :rating => 2, :review => 'Meh')
      review2 = Review.create(:user_id => 2, :food_cart_id => 1, :rating => 3, :review => 'Not bad')
      review3 = Review.create(:user_id => 2, :food_cart_id => 3, :rating => 5, :review => 'Good')

      # WHEN
      found_reviews = FoodCart.get_all_reviews(3)
      
      # THEN
      expect(found_reviews.length()).to eq(2)
      expect(found_reviews[0][:food_cart_id]).to eq(3)
      expect(found_reviews[0][:review]).to eq('Meh')
      expect(found_reviews[1][:food_cart_id]).to eq(3)
      expect(found_reviews[1][:review]).to eq('Good')
    end
  end
end
