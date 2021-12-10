class EquipmentCategory
  include Mongoid::Document
  store_in collection: "equipment-categories"
  field :index, type: String
	field :name, type: String
	field :equipment, type: Array
	field :url, type: String
end