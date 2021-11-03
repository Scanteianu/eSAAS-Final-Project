class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id, foreign_key: true
      t.integer :food_cart_id, foreign_key: true
      t.integer :rating
      t.string :review

      t.timestamps null: false
    end
    add_foreign_key :reviews, :users
    add_foreign_key :reviews, :food_carts
  end

end
