class AddCoordinatesToFoodCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :food_carts, :coordinates, :string
  end
end
