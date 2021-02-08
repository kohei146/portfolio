class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :books
  has_many :favorites
  # プロフィール画像アップロード
  mount_uploader :image, ImageUploader

  # ユーザー検索用のメソッド
  def self.search(content)
    if content.present?
      User.where('name LIKE ?', '%'+content+'%')
    else
      []
    end
  end

end
