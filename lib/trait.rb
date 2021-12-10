class Trait
  include Mongoid::Document
  store_in collection: "traits"
  field :index, type: String
	field :races, type: Array
	field :subraces, type: Array
	field :name, type: String
	field :desc, type: Array
	field :proficiencies, type: Array
	field :url, type: String
end