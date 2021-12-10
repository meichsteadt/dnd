class AbilityScore
  include Mongoid::Document
  store_in collection: "ability-scores"
  field :index, type: String
	field :name, type: String
	field :full_name, type: String
	field :desc, type: Array
	field :skills, type: Array
	field :url, type: String
end