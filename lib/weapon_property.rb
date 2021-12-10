class WeaponProperty
  include Mongoid::Document
  store_in collection: "weapon-properties"
  field :index, type: String
	field :name, type: String
	field :desc, type: Array
	field :url, type: String
end