require "rails_helper"
# https://relishapp.com/rspec/rspec-rails/docs/controller-specs

# RSpec.configure {|c| c.before { expect(controller).not_to be_nil }}
# RSpec.configure do |config|
#   config.infer_spec_type_from_file_location!
# end
describe CartsController, type: :controller do
  describe "loads from db" do
    it "loads a cart from db" do
      default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
      default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
      FoodCart.stub(:find_by_id).and_return({:name => 'the chicken dudes', :user_id => 4, :location => 'location1',:opening_time => default_opening_time, :closing_time => default_closing_time,:payment_options => 'cash, card', :top_rated_food => 'chicken over rice'})
      User.stub(:find_by_id).and_return({:email_id => 'test1@columbia.edu', :name => 'test1 user'})
      controller.getCartFromDb(1)
      cart = controller.currentCart
      expect(cart[:name]).to eq("the chicken dudes")
      expect(cart[:topRatedFood]).to eq("chicken over rice")
      expect(cart[:paymentOptions]).to eq(["cash","card"])
    end
  end
end
