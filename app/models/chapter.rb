class Chapter < ApplicationRecord
  include ObjectWithOrder
  validates :order, uniqueness: {scope: :book_id}

  belongs_to :book
  has_many :pages

  def first_page
    page = self.pages.order(:order).first
    page ||= self.pages.new
  end

  def name_with_number
    "Chapter #{self.order}: #{self.name}"
  end

  def id_with_book_id
    "book_#{self.book_id}_chapter_#{self.id}"
  end
end
