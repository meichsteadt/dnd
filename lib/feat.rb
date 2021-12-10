class Feat
  include Mongoid::Document
  store_in collection: "feats"
  field :index, type: String
	field :name, type: String
	field :prerequisites, type: Array
	field :desc, type: Array
	field :url, type: String
end