class UsersController < ApplicationController

  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @books = Book.where(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
     flash[:success] = "プロフィールを編集しました"
     redirect_to user_path(@user.id)
    else
     render "edit"
    end
  end

  def search
    @content = params[:content]
    @users = User.search(@content)
  end
  # タイムライン
  def index
    @books = Book.where(user_id: [current_user.id, * current_user.following_ids]).order(created_at: :desc).page(params[:page]).without_count.per(1)
  end

  private

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end

end
