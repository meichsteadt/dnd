class Page < ApplicationRecord
  @@monsters = nil
  @@spells = nil
  @@magic_items = nil
  include ObjectWithOrder
  validates :order, uniqueness: {scope: :chapter_id}

  belongs_to :chapter
  has_one :book, through: :chapter

  def self.get_monsters
    @@monsters ||= Monster.pluck(:id, :name).map {|e| [e[0].to_s, e[1]]}.to_h
  end

  def self.get_spells
    @@spells ||= Spell.pluck(:id, :name).map {|e| [e[0].to_s, e[1]]}.to_h
  end

  def self.get_magic_items
    @@magic_items ||= MagicItem.pluck(:id, :name).map {|e| [e[0].to_s, e[1]]}.to_h
  end

  def order_with_name
    "#{self.order} - #{self.name}"
  end

  def next
    self.chapter.pages.find_by(order: self.order + 1)
  end

  def prev
    self.chapter.pages.find_by(order: self.order - 1)
  end

  def parsed_html
    splits_with_white_space = self.html.split(/(<[^>]*>[^<]*<\/[^>]+>)/)
    splits_with_white_space.map {|e| self.parse_element(e)}.join("")
  end

  def hipster
    JSON.parse(RestClient.get("http://hipsum.co/api/?type=hipster").to_s)[0]
  end

  def get_element_tag(elem_string)
    match = elem_string.match(/(?<=<)[^>\/\s]+/)
    match = match ? match.to_s : elem_string
  end

  def parse_element(element)
    case get_element_tag(element)
    when "monster"
      id = element.match(/(?<=id=")[^"]+/).to_s
      monster_name = Page.get_monsters[id]
      return  "<p><a id='html_monster_#{id}' class='html_monster btn-link' data-id='#{id}'>#{monster_name}</a></p>"
    when "spell"
      id = element.match(/(?<=id=")[^"]+/).to_s
      spell_name = Page.get_spells[id]
      "<p><span class='spell' id='#{id}' data-id='#{id}'>#{spell_name.downcase}</span></p>"
    when "magic_item"
      id = element.match(/(?<=id=")[^"]+/).to_s
      item_name = Page.get_magic_items[id]
      "<p><span class='magic_item' id='#{id}' data-id='#{id}'>#{item_name.downcase}</span></p>"
    when "hipster"
      "<p>#{hipster}</p>"
    else
      return element
    end
  end
end
