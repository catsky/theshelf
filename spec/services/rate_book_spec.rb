require 'spec_helper'
require 'services/rate_book'

describe RateBook, type: :model do
  context '#rate!' do
    let(:user) { create :user }
    let(:book) { create :book }

    it 'requires a book, a rater and a rating value' do
      rate_book = RateBook.new(book: nil, rater: nil, rating: nil)

      expect(rate_book.rate!).to be_falsey
    end

    it 'rates a book for a user' do
      expect do
        rate_book_with_rating 3
      end.to change { Rating.all.size }.by(1)
    end

    context 'the book is already rated by the user' do
      it 'updates the rating when the given rating valid' do
        rate_book_with_rating 3

        expect do
          rate_book_with_rating 2
        end.to change { Rating.all.size }.by(0)
      end

      it 'deletes the rating when the given rating is invalid' do
        rate_book_with_rating 3

        expect do
          rate_book_with_rating RatingValues.highest + 1
        end.to change { Rating.all.size }.by(-1)
      end
    end

    it "updates the book's average rating" do
      expect(book).to receive(:update_average_rating!)

      rate_book_with_rating 3
    end
  end

  def rate_book_with_rating(rating)
    RateBook.new(book: book, rater: user, rating: rating).rate!
  end
end
