class BookCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book = book
    if comment.save
      redirect_to book_path(book), notice: 'コメントが追加されました'
    else
      redirect_to book_path(book), alert: 'コメントの追加に失敗しました'
    end
  end

  def destroy
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.find_by(book_id: book.id, id: params[:id])
    if comment
      comment.destroy
      redirect_back(fallback_location: book_path(book), notice: 'コメントが削除されました')
    else
      redirect_back(fallback_location: book_path(book), alert: 'コメントの削除に失敗しました')
    end
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end