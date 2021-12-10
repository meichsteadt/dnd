class Skill
  include Mongoid::Document
  store_in collection: "skills"
  field :index, type: String
	field :name, type: String
	field :desc, type: Array
	field :ability_score, type: Hash
	field :url, type: String
end