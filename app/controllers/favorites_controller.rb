class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save

    respond_to do |format|
      format.js   # create.js.erbを呼び出す
      format.html { redirect_to books_path }  # HTMLリクエストの場合の処理
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy

    respond_to do |format|
      format.js   # destroy.js.erbを呼び出す
      format.html { redirect_to books_path }  # HTMLリクエストの場合の処理
    end
  end
end
