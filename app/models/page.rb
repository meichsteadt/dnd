class Page < ApplicationRecord
  @@monsters = nil
  @@spells = nil
  @@magic_items = nil
  @@encounters = nil
  @@npcs = nil
  @@maps = nil

  include ObjectWithOrder
  include HTMLParser
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

  def self.get_encounters
    @@encounters ||= Encounter.pluck(:id, :name).map {|e| [e[0].to_s, e[1]]}.to_h
  end

  def self.get_npcs
    @@npcs ||= Npc.pluck(:id, :name).map {|e| [e[0].to_s, e[1]]}.to_h
  end

  def self.get_maps
    @@maps ||= Map.pluck(:id, :name).map {|e| [e[0].to_s, e[1]]}.to_h
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

end
