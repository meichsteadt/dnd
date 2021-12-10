class Subclass
  include Mongoid::Document
  store_in collection: "subclasses"
  field :index, type: String
	field :class, type: Hash
	field :name, type: String
	field :subclass_flavor, type: String
	field :desc, type: Array
	field :subclass_levels, type: String
	field :url, type: String
end