require_relative 'authorizable'

class User < ActiveRecord::Base
  include Clearance::User
  include Authorizable

  mount_uploader :avatar, AvatarUploader

  has_many :borrowed_books, through: :loans, source: :book
  has_many :loans

  validates :first_name, :last_name, presence: true
  validates :role, presence: true, inclusion: { in: UserRoles.all }
  validates :email, presence: true, uniqueness: true

  def currently_borrowed_books
    Book.joins(:loans).
      where(loans: { user_id: id, closed_at: nil })
  end

  def read_books
    Book.joins(:loans).
      where(loans: { user_id: id }).where.not(loans: { closed_at: nil }).uniq
  end

  def name=(name)
    self.first_name, self.last_name = name.split(' ', 2)
  end
end
