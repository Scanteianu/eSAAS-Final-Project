module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
World(WaitForAjax)

Given /the following carts exist/ do |carts_table|
  carts_table.hashes.each do |cart|
    cart['opening_time']=DateTime.parse(cart['opening_time']).strftime("%I:%M %p")
    cart['closing_time']=DateTime.parse(cart['closing_time']).strftime("%I:%M %p")
    FoodCart.create!(cart)
  end
end

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given /the following reviews exist/ do |reviews_table|
  reviews_table.hashes.each do |review|
    Review.create!(review)
  end
end

And /I am logged in/ do
  username = "logged_in_test_user@columbia.edu"
  post 'setusername', {:username=> username, :name=>"logged_in_test_name"}
  sessionMock = Hash.new
  sessionMock[:username] = username
  $injectedSession = sessionMock
end

Then /I should see the user review for "(.*)"/ do |username|
  found_user = User.find_by(name: username)
  found_review = Review.find_by(user_id: found_user.id)
  review_text = page.find('.list-of-reviews').text
  expect(review_text).to include(found_user.name)
  expect(review_text).to include("#{found_review.rating}/5")
  expect(review_text).to include(found_review.review)
end

When /I view more for "(.*)"/ do |food_cart_name|
  found_food_cart = FoodCart.find_by(name: food_cart_name)
  view_more_food_cart_link = page.find("a[href='/carts/cart/#{found_food_cart.id}']")
  view_more_food_cart_link.click
end

Then /I should see Google Maps/ do
  expect(page).to have_selector('.gmap-container iframe', visible: true)
end

Then /I should see ([1-9]+) markers on the map/ do |marker_num|
  markers = page.all('.gmap-container map')
  expect(markers.length).to eq(marker_num.to_i)
end

Then /I should see a map marker for "(.*)"/ do |map_marker_name|
  marker = page.find(".gmap-container map area[title='#{map_marker_name}']")
  expect(marker).not_to eq(nil)
end

Given /There is a Google Map/ do
  expect(page).to have_selector('.gmap-container iframe', visible: true)
end

When /I click on the Google Map food cart marker for "(.*)"/ do |map_marker_name|
  marker = page.find(".gmap-container map area[title='#{map_marker_name}']")
  marker.click
  sleep 0.5
end

Then /I should(?: (.*))? see "(.*)" card highlighted/ do |not_visible, food_cart_card_name|
  marker_class = page.find("##{food_cart_card_name.split(' ').join('-')}")[:class]
  highlighted_card_class = 'highlighted-food-cart-card'
  if not_visible != nil
     expect(marker_class).not_to include(highlighted_card_class)
  else
    expect(marker_class).to include(highlighted_card_class)
  end
end

And /^I post review?/ do
  click_button('Post Review')
  wait_for_ajax
end

And /^I update review$/ do
  page.all('.review-edit-container').each do |el|
    if !el[:class].include? 'hidden'
      el.find("[value='Update Review']").click
      wait_for_ajax
    end
  end
end

And /^I edit review$/ do
  page.find('.edit-review-button').click
end

And /^I delete review$/ do
  page.find('.delete-review-button').click
end 

And /I should only see "(.*)" review/ do |num_of_reviews|
  reviews = page.all('.list-of-reviews > div')
  expect(reviews.length).to eq(num_of_reviews.to_i)
end