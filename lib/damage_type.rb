class DamageType
  include Mongoid::Document
  store_in collection: "damage-types"
  field :index, type: String
	field :name, type: String
	field :desc, type: Array
	field :url, type: String
end