class Condition
  include Mongoid::Document
  store_in collection: "conditions"
  field :index, type: String
	field :name, type: String
	field :desc, type: Array
	field :url, type: String
end