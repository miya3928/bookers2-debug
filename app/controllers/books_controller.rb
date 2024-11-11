class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @book = Book.new
  end

    def show
      @book = Book.find(params[:id])       # 書籍データを1回の検索で取得
      @user = @book.user                   # 書籍に関連するユーザーを取得
      @book_comment = BookComment.new      # コメント用のオブジェクトを作成
      
      # 過去に一度も閲覧していない場合に閲覧数を記録
      unless ReadCount.find_by(user_id: current_user.id, book_id: @book.id)
        current_user.read_counts.create(book_id: @book.id)
      end  
      
      # 今日の閲覧履歴がない場合に閲覧数を記録
      unless ReadCount.where(created_at: Time.zone.now.all_day).find_by(user_id: current_user.id, book_id: @book.id)
        current_user.view_counts.create(book_id: @book.id)
      end  
    end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
  
    @books = Book.left_joins(:favorites)  # favoritesとのLEFT JOINを使用
                 .group('books.id')        # books.idでグループ化
                 .order('COUNT(favorites.id) DESC')  # いいねの数で降順に並べ替え
  
    @book = Book.new
    @user = current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      @user = current_user
      render 'index', notice: "You have updated book successfully."
    end
    @new_book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path, alert: "You are not authorized to edit or delete this book."
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end
end

