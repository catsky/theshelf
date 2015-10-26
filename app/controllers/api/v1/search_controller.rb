class API::V1::SearchController < API::BaseController
  before_action :require_login

  respond_to :json

  def search
    books = Book.search(search_params).decorate

    respond_with books.map(&:as_json)
  end

  private

  def search_params
    params.permit(:search_box)[:search_box]
  end
end
