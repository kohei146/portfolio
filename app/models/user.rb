class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, length: { in: 1..15 }
  validates :introduction, length: { maximum: 160 }

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
  # 自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # 相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

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
  # フォローするメソッド
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すメソッド
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしてるかどうか判定
  def following?(user)
    followings.include?(user)
  end

  # フォローの通知
  def create_notification_follow(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    # フォローされていない場合のみ通知を作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # ゲストログイン
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲスト'
    end
  end

  # アカウント作成時にメールを送信
  after_create :send_welcome_mail
  def send_welcome_mail
    ThanksMailer.send_signup_email(self).deliver
  end

end
