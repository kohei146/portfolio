class Book < ApplicationRecord
  belongs_to :user, optional: true
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # いいねしているか判定
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # いいねの通知
  def create_notification_favorite(current_user)
    # すでにいいねされているか確認
    # temp = Notification.where(["visitor_id = ? and visited_id = ? and book_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    # いいねされていない場合のみ通知を作成
    # if temp.blank?
      notification = current_user.active_notifications.new(
        book_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分の投稿にいいねした場合は通知済とする
      # if notification.visitor_id == notification.visited_id
        # notification.checked = true
      # end
      notification.save if notification.valid?
    # end
  end

  # コメントの通知
  def create_notification_comment(current_user, comment_id)
    # 本のレビューを書いたユーザーへ通知
    save_notification_comment(current_user, comment_id, self.user_id)
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、1つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      book_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  # 本棚に入っている本の数のランキング
  def self.create_books_ranks
    Book.all.group(:code).order('count(code) desc').limit(10)
  end

  # 本棚に入っている著者のランキング
  def self.create_authors_ranks
    Book.all.group(:author).order('count(author) desc').limit(3)
  end
end