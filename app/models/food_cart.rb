class FoodCart < ActiveRecord::Base
    belongs_to :user
    has_many :reviews, dependent: :destroy
end
