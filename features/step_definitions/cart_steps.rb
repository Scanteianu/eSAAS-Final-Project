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
