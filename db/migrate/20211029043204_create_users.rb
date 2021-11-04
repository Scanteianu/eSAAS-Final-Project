class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email_id,  unique_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
