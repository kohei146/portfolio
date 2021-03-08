module MessagesHelper

  # 最新メッセージのデータを取得して表示するメソッド
  def latest_message_preview(room)
    # 最新メッセージのデータを取得する
    message = room.messages.order(updated_at: :desc).limit(1)
    # 配列から取り出す
    message = message[0]
    # メッセージの有無を判定
    if message.present?
      # メッセージがあれば内容を表示
       message.message
    else
      # メッセージがなければ[ まだメッセージはありません ]を表示
      "[ まだメッセージはありません ]"
    end
  end

  # 最新メッセージのデータを取得して送信日時を表示するメソッド
  def latest_message_time(room)
    # 最新メッセージのデータを取得する
    message = room.messages.order(updated_at: :desc).limit(1)
    # 配列から取り出す
    message = message[0]
    # メッセージの有無を判定
    if message.present?
      # メッセージがあれば最新の送信日時を表示
       message.created_at.strftime("%Y/%m/%d %H:%M")
    else
      # メッセージがなければ空文字を表示
      ""
    end
  end

  # 相手ユーザー名を取得して表示するメソッド
  def opponent_user(room)
    # 中間テーブルから相手ユーザーのデータを取得
    entry = room.entries.where.not(user_id: current_user)
    # 相手ユーザーの名前を取得
    # name = entry[0].user.name
    entry[0].user
  end

end