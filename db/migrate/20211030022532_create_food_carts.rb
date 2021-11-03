class CreateFoodCarts < ActiveRecord::Migration
  def change
    create_table :food_carts do |t|
      t.string :name
      t.string :location
      t.integer :user_id, foreign_key: true
      t.datetime :opening_time
      t.datetime :closing_time
      t.string :payment_options
      t.string :top_rated_food

      t.timestamps null: false
    end
    add_foreign_key :food_carts, :users
  end
end
