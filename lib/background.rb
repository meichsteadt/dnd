class Background
  include Mongoid::Document
  store_in collection: "backgrounds"
  field :index, type: String
	field :name, type: String
	field :starting_proficiencies, type: Array
	field :language_options, type: Hash
	field :starting_equipment, type: Array
	field :starting_equipment_options, type: Array
	field :feature, type: Hash
	field :personality_traits, type: Hash
	field :ideals, type: Hash
	field :bonds, type: Hash
	field :flaws, type: Hash
	field :url, type: String
end