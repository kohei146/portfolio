class FavoritesController < ApplicationController
  def create
    favorite = current_user.favorites.build(book_id: params[:book_id])
    favorite.save
    @book = Book.find(params[:book_id])
    @book.create_notification_favorite(current_user)
    redirect_back(fallback_location:root_path) 
  end
  
  def destroy
    favorite = Favorite.find_by(book_id: params[:book_id], user_id: current_user.id)
    favorite.destroy
    redirect_back(fallback_location:root_path) 
  end
end
