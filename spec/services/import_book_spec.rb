require 'services/import_book'
require 'support/webmock_helpers'

describe ImportBook, type: :model do
  context '#perform' do
    it 'imports a book from goodreads' do
      WebmockHelpers.new.stub_isbn_search

      import_params = {
        isbn: '9780553801477',
        title: 'A Dance with Dragons (A Song of Ice and Fire, #5)'
      }
      importer = ImportBook.new(import_params[:isbn])

      book_params = importer.perform

      expect(book_params[:isbn]).to eq import_params[:isbn]
      expect(book_params[:title]).to eq import_params[:title]
    end
  end
end
