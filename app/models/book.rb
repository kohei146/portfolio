class Book < ApplicationRecord
  belongs_to :users, optional: true
  has_many :favorites
  
  # いいねしているか判定
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
end
