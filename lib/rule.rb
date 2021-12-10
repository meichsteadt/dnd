class Rule
  include Mongoid::Document
  store_in collection: "rules"
  field :name, type: String
	field :index, type: String
	field :desc, type: String
	field :subsections, type: Array
	field :url, type: String
end