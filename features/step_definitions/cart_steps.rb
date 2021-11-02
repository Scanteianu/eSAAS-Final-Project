Given /the following carts exist/ do |carts_table|
  carts_table.hashes.each do |cart|
    cart['opening_time']=DateTime.parse(cart['opening_time']).strftime("%I:%M %p")
    cart['closing_time']=DateTime.parse(cart['closing_time']).strftime("%I:%M %p")
    FoodCart.create cart
  end
end

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    User.create user
  end
end

Given /the following reviews exist/ do |reviews_table|
  reviews_table.hashes.each do |review|
    Review.create review
  end
end

Then /I should see the user review for "(.*)"/ do |username|
  found_user = User.find_by(name: username)
  found_review = Review.find_by(user_id: found_user.id)
  review_text = page.find('.list-of-reviews').text
  expect(review_text).to include(found_user.name)
  expect(review_text).to include("#{found_review.rating}/5")
  expect(review_text).to include(found_review.review)
end