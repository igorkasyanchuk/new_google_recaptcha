class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  def index
    @books = Book.all
  end

  # GET /books/1
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # book /books
  def create
    @book = Book.new(book_params)

    humanity_datailed =
      NewGoogleRecaptcha.get_humanity_detailed(
        params[:new_google_recaptcha_token],
        'manage_books',
        NewGoogleRecaptcha.minimum_score,
        @book
      )

    @book.humanity_score = humanity_datailed[:actual_score]

    if humanity_datailed[:is_human] && @book.save
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /books/1
  def update
    humanity_datailed =
      NewGoogleRecaptcha.get_humanity_detailed(
        params[:new_google_recaptcha_token], 'manage_books'
      )

    flash[:error] = "Looks like you are not a human" unless humanity_datailed[:is_human]

    if humanity_datailed[:is_human] &&
      @book.update(params_with_humanity(humanity_datailed[:actual_score]))
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:author, :title)
  end

  def params_with_humanity(score)
    book_params.merge(humanity_score: score)
  end
end
