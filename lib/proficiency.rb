class Proficiency
  include Mongoid::Document
  store_in collection: "proficiencies"
  field :index, type: String
	field :type, type: String
	field :name, type: String
	field :classes, type: Array
	field :races, type: Array
	field :url, type: String
	field :reference, type: Hash
	field :references, type: Array
end