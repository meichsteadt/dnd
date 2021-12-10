class Subrace
  include Mongoid::Document
  store_in collection: "subraces"
  field :index, type: String
	field :name, type: String
	field :race, type: Hash
	field :desc, type: String
	field :ability_bonuses, type: Array
	field :starting_proficiencies, type: Array
	field :languages, type: Array
	field :racial_traits, type: Array
	field :url, type: String
end