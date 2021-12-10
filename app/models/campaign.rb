class Campaign < ApplicationRecord
  validates :name, presence: true, uniqueness: {scope: :user_id}

  has_many :books
  has_many :chapters, through: :books
  has_many :pages, through: :chapters

  def first_book
    book = self.books.order(:order).first
    book ||= self.books.new
  end
end
