class Race
  include Mongoid::Document
  store_in collection: "races"
  field :index, type: String
	field :name, type: String
	field :speed, type: Integer
	field :ability_bonuses, type: Array
	field :alignment, type: String
	field :age, type: String
	field :size, type: String
	field :size_description, type: String
	field :starting_proficiencies, type: Array
	field :starting_proficiency_options, type: Hash
	field :languages, type: Array
	field :language_desc, type: String
	field :traits, type: Array
	field :subraces, type: Array
	field :url, type: String
end