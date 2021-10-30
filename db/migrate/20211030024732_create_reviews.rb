class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :user_id, foreign_key: true
      t.integer :food_cart_id, foreign_key: true
      t.integer :rating
      t.string :review

      t.timestamps null: false
    end
    # add_foreign_key :reviews, :users, column: :reviewer_id, primary_key: "email_id"
    # add_foreign_key :reviews, :users, column: :cart_id, primary_key: "id"
  end
  
end
