class BooksController < ApplicationController
  
  before_action :authenticate_user!, except: [:index]
  
  def index
    @book_ranks = Book.create_books_ranks
    @author_ranks = Book.create_authors_ranks
  end

  def show
    @book = Book.find(params[:id])
    @comment = Comment.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to user_path(current_user.id)
      flash[:success] = "本棚に登録しました"
    else
      render 'search'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
       flash[:success] = "レビューを投稿しました"
       redirect_to book_path(@book.id)
    else
       render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

  end

  def search
    @book = Book.new

    # 書籍検索APIの処理
    if params[:keyword].present?
      require 'net/http'
      url = 'https://www.googleapis.com/books/v1/volumes?q='
      request = url + params[:keyword] + '&maxResults=40'
      enc_str = URI.encode(request)
      uri = URI.parse(enc_str)
      json = Net::HTTP.get(uri)
      @bookjson = JSON.parse(json)

      count = 40 # 検索結果に表示する数
      @books = Array.new(count).map { Array.new(4) }
      count.times do |x|
        # タイトルを取得
        @books[x][0] = @bookjson.dig("items", x, "volumeInfo", "title")
        # サムネイルを取得
        @books[x][1] = @bookjson.dig("items", x, "volumeInfo", "imageLinks", "thumbnail")
        # 著者名を取得
        @books[x][2] = @bookjson.dig("items", x, "volumeInfo", "authors")
        @books[x][2] = @books[x][2].join(',') if @books[x][2] # 複数著者をカンマで区切る
        # 書籍コードを取得
        @books[x][3] = @bookjson.dig("items", x, "volumeInfo", "industryIdentifiers", 0, "identifier")
        # 書籍説明を取得
        @books[x][4] = @bookjson.dig("items", x, "volumeInfo", "description")
        # 出版日を取得
        @books[x][5] = @bookjson.dig("items", x, "volumeInfo", "publishedDate")
      end
      @books = Kaminari.paginate_array(@books).page(params[:page]).per(10)
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :image, :author, :code, :description, :published_date, :user_id, :review, :rate)
  end

end
