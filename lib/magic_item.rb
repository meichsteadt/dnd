class MagicItem
  include Mongoid::Document
  store_in collection: "magic-items"
  field :index, type: String
	field :name, type: String
	field :equipment_category, type: Hash
	field :desc, type: Array
	field :url, type: String

  def meta_info
    item_type, rarity = self.desc[0].split(", ")
    {item_type: item_type, rarity: rarity}
  end

  def description
    self.desc[1..-1]
  end
end
