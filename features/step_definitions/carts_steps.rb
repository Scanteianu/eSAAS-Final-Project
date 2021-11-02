Given /the following food carts exist/ do |food_carts_table|
    food_carts_table.hashes.each do |food_cart|
    FoodCart.create food_cart
  end
end