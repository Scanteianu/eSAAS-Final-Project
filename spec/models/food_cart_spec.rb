require 'rails_helper'

RSpec.describe FoodCart, type: :model do
  describe 'get_all_reviews' do
    it 'gets all reviews for specified food cart id successfully' do
      # GIVEN
      test_user = User.create!(:email_id => 'test@columbia.edu', :name => 'test user')
      test_user2 = User.create!(:email_id => 'test2@columbia.edu', :name => 'test user 2')
      owner_user = User.create()
      default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
      default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
      test_food_cart = FoodCart.create!({
        :name => 'the halal guys',
        :user_id => owner_user[:id],
        :location => 'location1',
        :opening_time => default_opening_time,
        :closing_time => default_closing_time,
        :payment_options => 'cash, card, venmo',
        :top_rated_food => 'chicken over rice'
      })
      test_food_cart = FoodCart.create!({
        :name => 'luoyang',
        :user_id => owner_user[:id],
        :location => 'location2',
        :opening_time => default_opening_time,
        :closing_time => default_closing_time,
        :payment_options => 'cash',
        :top_rated_food => 'Mapo tofu'
      })
      review = Review.create!(:user_id => 1, :food_cart_id => 2, :rating => 2, :review => 'Meh')
      review2 = Review.create!(:user_id => 2, :food_cart_id => 1, :rating => 3, :review => 'Not bad')
      review3 = Review.create!(:user_id => 2, :food_cart_id => 2, :rating => 5, :review => 'Good')

      # WHEN
      found_reviews = FoodCart.get_all_reviews(2)
      
      # THEN
      expect(found_reviews.length()).to eq(2)
      expect(found_reviews[0][:food_cart_id]).to eq(2)
      expect(found_reviews[0][:review]).to eq('Meh')
      expect(found_reviews[1][:food_cart_id]).to eq(2)
      expect(found_reviews[1][:review]).to eq('Good')
    end
  end
end
