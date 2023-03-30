class Api::V1::BooksController < ApplicationController
  before_action :set_book, only: %i[ update show destroy ]

  def index 
    @books = Book.page(params[:page].to_i)
    render json: {
      message: "success",
      data: @books,
      meta: pagination(@books)
    }
  end  

  def create 
    @book = Book.new(book_params)
    @book.save ? response_ok(@book, 200) : 
                 response_error(@book.errors, 422)
  end

  def update 
    @book.update(book_params) ? response_ok(@book, 200) :
                   response_error(@book.errors, 422)
  end

  def show 
    response_ok(@book, 200)
  end

  def destroy
    @book.destroy 
    response_ok(@book, 200) 
  end

  private 

  def book_params 
    params.require(:book).permit(:name, :writer_id, :image)
  end

  def set_book 
    @book = Book.find_by(id: params[:id])
    response_error("Book not found", 404) if @book.nil?
  end
end
