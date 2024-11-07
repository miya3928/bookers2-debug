class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book = @book

    if @comment.save
      respond_to do |format|
        format.js   # create.js.erbを呼び出す
        format.html { redirect_to book_path(@book) }
      end
    else
      # エラーハンドリングを追加する場合
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.find_by(book_id: @book.id, id: params[:id])

    if @comment.destroy
      respond_to do |format|
        format.js   # destroy.js.erbを呼び出す
        format.html { redirect_to book_path(@book) }
      end
    else
      # エラーハンドリングを追加する場合
    end
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end