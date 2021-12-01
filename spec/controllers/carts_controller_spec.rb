require "rails_helper"
# https://relishapp.com/rspec/rspec-rails/docs/controller-specs

# RSpec.configure {|c| c.before { expect(controller).not_to be_nil }}
# RSpec.configure do |config|
#   config.infer_spec_type_from_file_location!
# end
describe CartsController, type: :controller do
  describe "loads from db" do
    default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
    default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
    let(:test_cart) { FoodCart.create name: 'the chicken dudes', user_id: 4,
      location: 'location1',
      opening_time: default_opening_time, 
      closing_time: default_closing_time,
      payment_options: 'cash, card', 
      top_rated_food: 'chicken over rice'
    }

    it "loads a cart from db" do
      test_cart.image.attach(io: File.open('spec/controllers/test.jpg'), filename: 'test.jpg', content_type: 'image/jpg')
      User.stub(:find_by_id).and_return({:email_id => 'test1@columbia.edu', :name => 'test1 user'})
      Review.stub(:where).and_return([{:user_id => 4, :food_cart_id => 1,:rating => 5, :review => "the food's good"}])
      controller.getCartFromDb(test_cart.id)
      cart = controller.currentCart
      expect(cart[:name]).to eq("the chicken dudes")
      expect(cart[:topRatedFood]).to eq("chicken over rice")
      expect(cart[:paymentOptions]).to eq(["cash","card"])
      expect(cart[:image]).not_to be_nil
    end
  end

  describe "set username" do
    it "sets username" do
      get 'setusername', {:params =>{:username=> "dan",:name=>"dan"}}
      expect(controller.session[:username]).to eq("dan")
    end
    it "clears username" do
      get 'setusername', {:params =>{:username=> "Nil",:name=>"Nil"}}
      expect(controller.session[:username]).to eq(nil)
    end
  end

  describe "index" do
    it "should assign the carts variable" do
      owner_user = User.create!(:name => 'owner', :email_id => 'owneremail@gmail.com')
      default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
      default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
      test_food_cart = FoodCart.create!({
        :name => 'the halal guys',
        :user_id => owner_user[:id],
        :location => 'location2',
        :coordinates => '10, 20',
        :opening_time => default_opening_time,
        :closing_time => default_closing_time,
        :payment_options => 'cash, card, venmo',
        :top_rated_food => 'chicken over rice',
      })
      get :index
      expect(@controller.instance_variable_get(:@carts).length).to eq(1)
      expect(@controller.instance_variable_get(:@carts)[0][:name]).to eq(test_food_cart[:name])
      expect(@controller.instance_variable_get(:@carts)[0][:location]).to eq(test_food_cart[:location])
      expect(@controller.instance_variable_get(:@carts)[0][:coordinates]).to eq(test_food_cart[:coordinates])
      expect(@controller.instance_variable_get(:@carts)[0][:opening_time]).not_to eq(nil)
      expect(@controller.instance_variable_get(:@carts)[0][:closing_time]).not_to eq(nil)
      expect(@controller.instance_variable_get(:@carts)[0][:payment_options]).to eq(test_food_cart[:payment_options])
      expect(@controller.instance_variable_get(:@carts)[0][:top_rated_food]).to eq(test_food_cart[:top_rated_food])
    end
  end

  describe "cart" do
    before(:each) do
      @owner_user = User.create!(:name => 'owner', :email_id => 'owneremail@gmail.com')
      @test_user = User.create!(:email_id => 'test@columbia.edu', :name => 'test user')
      @test_user2 = User.create!(:email_id => 'test2@columbia.edu', :name => 'test user 2')
      default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
      default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
      @test_food_cart = FoodCart.create!({
        :name => 'the halal guys',
        :user_id => @owner_user[:id],
        :location => 'location2',
        :coordinates => '10, 20',
        :opening_time => default_opening_time,
        :closing_time => default_closing_time,
        :payment_options => 'cash, card, venmo',
        :top_rated_food => 'chicken over rice',
        :open_on_days => 'Sun, Sat',
      })
      @review = Review.create!(:user_id => @test_user[:id], :food_cart_id => @test_food_cart[:id], :rating => 3, :review => 'Not bad')
    end

    it "should assign current cart variable" do
      expected_cart = Hash.new
      expected_cart[:cart_id] = @test_food_cart[:id]
      expected_cart[:name] = @test_food_cart[:name]
      expected_cart[:location] = @test_food_cart[:location]
      expected_cart[:coordinates] = @test_food_cart[:coordinates]
      expected_cart[:owner] = @owner_user[:name]
      expected_cart[:paymentOptions] = @test_food_cart[:payment_options].split(", ")
      expected_cart[:topRatedFood] = @test_food_cart[:top_rated_food]
      expected_cart[:openHours] = "04:30AM"
      expected_cart[:closeHours] = "01:00PM"
      expected_cart[:openOnDays] = @test_food_cart[:open_on_days]

      get :cart, params: { id: @test_food_cart[:id] }

      expect(@controller.instance_variable_get(:@currentCart)).to eq(expected_cart)
    end

    it "should assign hasUserWrittenReview variable" do
      get 'setusername', :params =>{ :username => @test_user[:email_id], :name => @test_user[:name] }
      get :cart, params: { id: @test_food_cart[:id] }

      expect(@controller.instance_variable_get(:@hasUserWrittenReview)).to eq(true)
    end

    it "should assign current reviews variable" do
      get :cart, params: { id: @test_food_cart[:id] }

      expect(@controller.instance_variable_get(:@currentReviews)[0][:username]).to eq(@test_user[:name])
      expect(@controller.instance_variable_get(:@currentReviews)[0][:rating]).to eq(@review[:rating])
      expect(@controller.instance_variable_get(:@currentReviews)[0][:review]).to eq(@review[:review])
    end
  end

  describe "add_review" do
    before(:each) do
      default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
      default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
      owner_user = User.create()
      @test_food_cart = FoodCart.create!({
        :name => 'the halal guys',
        :user_id => owner_user[:id],
        :location => 'location2',
        :coordinates => '10, 20',
        :opening_time => default_opening_time,
        :closing_time => default_closing_time,
        :payment_options => 'cash, card, venmo',
        :top_rated_food => 'chicken over rice'
      })
      @test_user = User.create!(:name => 'testuser', :email_id => 'test@columbia.edu')
    end

    it "should not create the review without login" do
      # food cart id must match one currently in DB
      expect {
          post :add_review, params: { cart_id: @test_food_cart[:id], id: 1, initial_cart_review: { review: 'review text', rating: 1 } }
      }.to raise_error(Exception)
    end

    it "should create the review successfully with login" do
      review_text = 'review text'
      review_rating = "1"
      expected_review_hash = Hash.new
      expected_review_hash[:email_id] = @test_user[:email_id]
      expected_review_hash[:food_cart_id] = @test_food_cart[:id].to_s
      expected_review_hash[:hasReadWriteAccess] = true
      expected_review_hash[:id] = 1
      expected_review_hash[:rating] = review_rating
      expected_review_hash[:review] = review_text
      expected_review_hash[:user_id] = @test_user[:id]
      expected_review_hash[:username] = @test_user[:name]

      # food cart id must match one currently in DB
      get 'setusername', :params =>{ :username => @test_user[:email_id], :name => @test_user[:name] }
      post :add_review, params: { cart_id: @test_food_cart[:id], id: 1, initial_cart_review: { review: review_text, rating: review_rating } }

      expect(@controller.instance_variable_get(:@review_to_display)).to eq(expected_review_hash)
    end

    it "should redirect to the cart path" do
      get 'setusername', :params =>{ :username => @test_user[:email_id], :name => @test_user[:name] }
      post :add_review, params: { cart_id: @test_food_cart[:id], id: 1, initial_cart_review: { review: 'review text', rating: 1 } }

      expect(response).to redirect_to(cart_path(1))
    end
  end

  describe "verify_user" do 

    context "user email is nil" do
      it "return false" do
        value=@controller.verify_user(nil)
        expect(value).to eq(false)
      end
    end
    context "user email is not nil" do
      context "user email includes columbia.edu or barnard.edu" do
        it "returns true" do
          value1=@controller.verify_user("test1@columbia.edu")
          expect(value1).to eq(true)
          value2=@controller.verify_user("test1@barnard.edu")
          expect(value2).to eq(true)
        end
      end
      context "user email does not include columbia.edu or barnard.edu" do
        it "returns false" do
          value=@controller.verify_user("test1@gmail.com")
          expect(value).to eq(false)
        end
      end
    end 
  end
  
  describe "edit_review" do
    before(:each) do
      default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
      default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
      owner_user = User.create()
      @test_food_cart = FoodCart.create!({
        :name => 'the halal guys',
        :user_id => owner_user[:id],
        :location => 'location2',
        :coordinates => '10, 20',
        :opening_time => default_opening_time,
        :closing_time => default_closing_time,
        :payment_options => 'cash, card, venmo',
        :top_rated_food => 'chicken over rice'
      })
      @test_user = User.create!(:name => 'testuser', :email_id => 'test@columbia.edu')
      @test_review = User.create_review(@test_user[:id], @test_food_cart[:id], 3, 'the food was meh')
    end

    it "should not update the review without login" do
      # food cart id must match one currently in DB
      expect {
          post :edit_review, params: { cart_id: @test_food_cart[:id], id: @test_review[:id], edit_cart_review: { review: 'the food was meh...', rating: 2 } }
      }.to raise_error(Exception)
    end

    it "should update the review successfully with login" do
      review_text = 'the food was meh...'
      review_rating = "2"
      expected_review_hash = Hash.new
      expected_review_hash[:email_id] = @test_user[:email_id]
      expected_review_hash[:hasReadWriteAccess] = true
      expected_review_hash[:id] = 1
      expected_review_hash[:rating] = review_rating
      expected_review_hash[:review] = review_text
      expected_review_hash[:username] = @test_user[:name]

      # food cart id must match one currently in DB
      get 'setusername', :params =>{ :username => @test_user[:email_id], :name => @test_user[:name] }
      post :edit_review, params: { cart_id: @test_food_cart[:id], id: @test_review[:id], edit_cart_review: { review: review_text, rating: review_rating } }

      expect(@controller.instance_variable_get(:@updated_review)).to eq(expected_review_hash)
    end
  end

  describe "delete_review" do
    before(:each) do
      default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
      default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
      owner_user = User.create()
      @test_food_cart = FoodCart.create!({
        :name => 'the halal guys',
        :user_id => owner_user[:id],
        :location => 'location2',
        :coordinates => '10, 20',
        :opening_time => default_opening_time,
        :closing_time => default_closing_time,
        :payment_options => 'cash, card, venmo',
        :top_rated_food => 'chicken over rice'
      })
      @test_user = User.create!(:name => 'testuser', :email_id => 'test@columbia.edu')
      @test_review = User.create_review(@test_user[:id], @test_food_cart[:id], 3, 'the food was meh')
    end

    it "should not delete the review without login" do
      # food cart id must match one currently in DB
      expect {
          post :delete_review, params: { cart_id: @test_food_cart[:id], id: @test_review[:id], edit_cart_review: { review: 'the food was meh...', rating: 2 } }
      }.to raise_error(Exception)
    end

    it "should set deleted review Id successfully with login" do
      # food cart id must match one currently in DB
      get 'setusername', :params =>{ :username => @test_user[:email_id], :name => @test_user[:name] }
      post :delete_review, params: { cart_id: @test_food_cart[:id], id: @test_review[:id] }

      expect(@controller.instance_variable_get(:@deleted_review_id)).to eq(@test_review[:id].to_s)
    end

    it "should set deleted review cart successfully with login" do
      # food cart id must match one currently in DB
      get 'setusername', :params =>{ :username => @test_user[:email_id], :name => @test_user[:name] }
      post :delete_review, params: { cart_id: @test_food_cart[:id], id: @test_review[:id] }

      deleted_review_cart = FoodCart.find_by_id(@test_review[:id])

      expect(@controller.instance_variable_get(:@deleted_review_cart)).to eq(deleted_review_cart)
    end

    it "should create the review successfully with login" do
      review_text = 'the food was meh...'
      review_rating = "2"
      expected_review_hash = Hash.new
      expected_review_hash[:email_id] = @test_user[:email_id]
      expected_review_hash[:hasReadWriteAccess] = true
      expected_review_hash[:id] = 1
      expected_review_hash[:rating] = review_rating
      expected_review_hash[:review] = review_text
      expected_review_hash[:username] = @test_user[:name]

      # food cart id must match one currently in DB
      get 'setusername', :params =>{ :username => @test_user[:email_id], :name => @test_user[:name] }
      post :delete_review, params: { cart_id: @test_food_cart[:id], id: @test_review[:id] }

      deleted_review = Review.find_by_id(@test_review[:id])

      expect(deleted_review).to eq(nil)
    end
  end

  describe "upsert cart" do
    before(:context) do
      test_username = "test@columbia.edu"
      $injectedSession = { :username => test_username }
    end
    it "create a new cart" do
      get :new
      expected_cart = Hash.new
      expected_cart[:name] = "the new cart"
      expected_cart[:location] = "113th broadway"
      expected_cart[:opening_time] = "14:03"
      expected_cart[:closing_time] = "02:35"
      expected_cart[:payment_options] = "Cash, Venmo"

      post :create, params:{
        "cart"=>{
          "name"=>"the new cart",
          "location"=>"113th broadway",
          "opening_time"=>"14:03",
          "closing_time"=>"02:35",
          "payment_options"=>{"Cash"=>"1", "Venmo"=>"1"}
        }
      }
      expect(@controller.instance_variable_get(:@cart)[:name]).to eq(expected_cart[:name])
      expect(@controller.instance_variable_get(:@cart)[:location]).to eq(expected_cart[:location])
      expect(@controller.instance_variable_get(:@cart)[:coordinates]).to eq(expected_cart[:coordinates])
      expect(@controller.instance_variable_get(:@cart)[:opening_time]).not_to eq(nil)
      expect(@controller.instance_variable_get(:@cart)[:closing_time]).not_to eq(nil)
      expect(@controller.instance_variable_get(:@cart)[:payment_options]).to eq(expected_cart[:payment_options])
    end

    it "edit an existing cart" do
      test_cart = FoodCart.create!({
        :name => 'the exisitng cart',
        :location => '113th broadway',
        :opening_time => "14:03",
        :closing_time => "02:35",
        :payment_options => "Cash, Venmo",
      })
      img = fixture_file_upload('spec/controllers/test.jpg', 'image/jpg')

      get :edit, params: { id: test_cart[:id] }
      post :update, params:{
        "id" => test_cart[:id] ,
        "cart"=>{
          "name"=>"the modified cart",
          "location"=>"123th broadway",
          "opening_time"=>"14:03",
          "closing_time"=>"02:35",
          "payment_options"=>{"Cash"=>"1"},
          "image"=> img
        }
      }
      expect(response).to redirect_to cart_path(test_cart[:id])
      modified_cart = FoodCart.find_by_id(test_cart[:id])
      expect(modified_cart.name).to eq("the modified cart")
      expect(modified_cart.location).to eq("123th broadway")
      expect(modified_cart.opening_time).not_to eq(nil)
      expect(modified_cart.closing_time).not_to eq(nil)
      expect(modified_cart.payment_options).to eq("Cash")
      expect(modified_cart.image.attached?).to eq(true)
    end
    
    after(:context) do
      $injectedSession = nil
    end
  end
end
