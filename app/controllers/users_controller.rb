class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @books = Book.where(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def search
    @content = params[:content]
    @users = User.search(@content)
  end

  def index
    @books = Book.where(user_id: [current_user.id, * current_user.following_ids]).order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end

end
