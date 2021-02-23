class CommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    comment = current_user.comments.new(comment_params)
    comment.book_id = @book.id
    @book_comment = comment.book
    if comment.save
      @book_comment.create_notification_comment(current_user, comment.id)
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    Comment.find_by(id: params[:id], book_id: params[:book_id]).destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
