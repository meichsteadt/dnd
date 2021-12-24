class Feature
  include Mongoid::Document
  store_in collection: "features"
  field :index, type: String
	field :character_class, type: Hash
	field :name, type: String
	field :level, type: Integer
	field :prerequisites, type: Array
	field :desc, type: Array
	field :url, type: String
end
