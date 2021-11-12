users = [{:email_id => 'test1@columbia.edu', :name => 'test1 user'},
    {:email_id => 'test2@columbia.edu', :name => 'test2 user'},
    {:email_id => 'test3@columbia.edu', :name => 'test3 user'},
    {:email_id => 'owner_person@gmail.com', :name => 'owner user'},
 ]

users.each do |user|
    User.create!(user)
end

default_opening_time = DateTime.parse('9:30:00').strftime("%I:%M %p")
default_closing_time = DateTime.parse('18:00:00').strftime("%I:%M %p")
food_carts = [
    {:name => 'mexican cart', :user_id => 4, :location => 'location1', :coordinates => '40.80877070458994,-73.96310377081672', :opening_time => default_opening_time, :closing_time => default_closing_time,:payment_options => 'cash, card', :top_rated_food => 'taco al pastor'},
    {:name => 'the halal guys', :user_id => 4, :location => 'location2', :coordinates => '40.80680499795128,-73.96078581662722', :opening_time => default_opening_time, :closing_time => default_closing_time,:payment_options => 'cash, card, venmo', :top_rated_food => 'chicken over rice'},
    {:name => 'dumpling corner', :user_id => 4, :location => 'location3', :coordinates => '40.80753715418158,-73.96469123200576', :opening_time => default_opening_time, :closing_time => default_closing_time,:payment_options => 'cash, venmo', :top_rated_food => 'soup dumplings'},
]
food_carts.each do |food_cart|
    FoodCart.create!(food_cart)
end

reviews = [
    {:user_id => 3, :food_cart_id => 1,:rating => 5, :review => "the food's good"},
    {:user_id => 1, :food_cart_id => 2,:rating => 4, :review => "will recommend"},
    {:user_id => 2, :food_cart_id => 3,:rating => 5, :review => "bang for the buck"},
]
reviews.each do |review|
    Review.create!(review)
end
