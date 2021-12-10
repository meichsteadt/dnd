class Class
  include Mongoid::Document
  store_in collection: "classes"
  field :index, type: String
	field :name, type: String
	field :hit_die, type: Integer
	field :proficiency_choices, type: Array
	field :proficiencies, type: Array
	field :saving_throws, type: Array
	field :starting_equipment, type: Array
	field :starting_equipment_options, type: Array
	field :class_levels, type: String
	field :multi_classing, type: Hash
	field :subclasses, type: Array
	field :url, type: String
end