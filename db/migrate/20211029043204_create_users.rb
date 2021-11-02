class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email_id,  primary_key: true
      t.string :name, primary_key: false

      t.timestamps null: false, primary_key: false
    end
  end
end
