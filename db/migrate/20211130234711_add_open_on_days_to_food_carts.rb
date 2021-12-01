class AddOpenOnDaysToFoodCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :food_carts, :open_on_days, :string
  end
end
