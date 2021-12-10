class Book < ApplicationRecord
  include ObjectWithOrder
  validates :order, uniqueness: {scope: :campaign_id}

  belongs_to :campaign
  has_many :chapters
  has_many :pages, through: :chapters
  
  before_destroy do |book|
    book.update_orders(9999999999)
  end

  def first_chapter
    chapter = self.chapters.order(:order).first
    chapter ||= self.chapters.new
  end

  def first_page
    self.first_chapter.first_page
  end

  def name_with_number
    "Book #{self.order}: #{self.name}"
  end

end
