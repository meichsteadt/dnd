class Equipment
  include Mongoid::Document
  store_in collection: "equipment"
  field :index, type: String
	field :name, type: String
	field :equipment_category, type: Hash
	field :weapon_category, type: String
	field :weapon_range, type: String
	field :category_range, type: String
	field :cost, type: Hash
	field :damage, type: Hash
	field :range, type: Hash
	field :weight, type: Integer
	field :properties, type: Array
	field :url, type: String
end