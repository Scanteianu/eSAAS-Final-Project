require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    owner_user = User.create!()
    @test_user = User.create!(:email_id => 'test@columbia.edu', :name => 'test user')
    @test_user2 = User.create!(:email_id => 'test2@columbia.edu', :name => 'test user 2')
    default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
    default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
    @test_food_cart = FoodCart.create!({
      :name => 'the halal guys',
      :user_id => owner_user[:id],
      :location => 'location2',
      :opening_time => default_opening_time,
      :closing_time => default_closing_time,
      :payment_options => 'cash, card, venmo',
      :top_rated_food => 'chicken over rice'
    })
    @review = Review.create!(:user_id => @test_user[:id], :food_cart_id => @test_food_cart[:id], :rating => 3, :review => 'Not bad')
  end

  describe "create_review" do
    it 'creates a user review successfully' do
      rating = 5
      review = 'The food was amazing!'
      User.create_review(@test_user2[:id], @test_food_cart[:id], rating, review)
      found_review = Review.find_by(:user_id => @test_user2[:id], :food_cart_id => @test_food_cart[:id])

      expect(found_review[:user_id]).to eq(@test_user2[:id])
      expect(found_review[:food_cart_id]).to eq(@test_food_cart[:id])
      expect(found_review[:rating]).to eq(rating)
      expect(found_review[:review]).to eq(review)
    end
  end

  describe "reviews_by_me" do
    it 'gets all reviews written by the user' do
      reviews = User.reviews_by_me(@test_user[:id])
      
      expect(reviews.length()).to eq(1)
      expect(reviews[0][:user_id]).to eq(@test_user[:id])
      expect(reviews[0][:rating]).to eq(@review[:rating])
      expect(reviews[0][:review]).to eq(@review[:review])
    end
  end

  describe "delete_reviews" do
    it 'deletes the review successfully' do
      User.delete_review(@review[:id])
      deleted_review = Review.find_by(:user_id => @test_user[:id], :food_cart_id => @test_food_cart[:id])
      reviews = Review.all
      
      expect(deleted_review).to eq(nil)
      expect(reviews.length()).to eq(0)
    end
  end
end
