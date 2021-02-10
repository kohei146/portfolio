class MessagesController < ApplicationController
  def show
    @user = User.find(params[:id])
    # ログインユーザーのidが入ったroom_idのみ配列で取得
    rooms = current_user.entries.pluck(:room_id)
    # user_idが@user且つroom_idがrooms配列の中にある数値のものを取得
    entry = Entry.find_by(user_id: @user.id, room_id: rooms)
    
    if entry.nil?
      # 取得していない場合、roomのレコードとentryのレコードを作成
      @room = Room.new
      @room.save
      Entry.create(user_id: current_user.id, room_id: @room.id)
      Entry.create(user_id: @user.id, room_id: @room.id)
    else
      # 取得していた場合は、roomテーブルのレコードを@roomに代入
      @room = entry.room
    end
    @messages = @room.messages
    @message = Message.new(room_id: @room.id)
  end

  def create
    @message = current_user.messages.new(message_params)
    @message.save
  end
  
  def index
    @rooms = current_user.rooms
  end

  private

  def message_params
    params.require(:message).permit(:message, :room_id)
  end
end
