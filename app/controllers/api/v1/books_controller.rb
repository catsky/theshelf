module API
  module V1
    class BooksController < ApplicationController
      authorize_resource

      def index
        books = Book.all

        render json_vendored: books
      end

      def show
        render json_vendored: Book.find(params[:id])
      end

      def destroy
        book = Book.find(params[:id])
        book.destroy
        render json_vendored: book
      end

      def update
        book = Book.find(params[:id])
        book.update(book_params)
        render json_vendored: book
      end

      def create
        book = Book.new(book_params)

        if book.save
          render json_vendored: book, status: :created, location: book_url(book)
        else
          head :bad_request
        end
      end

      private

      def book_params
        params.require(:book).permit(:authors, :owner, :pages, :published_on, :subtitle, :summary, :title, :url, :cover, :cover_cache, :isbn)
      end
    end
  end
end
