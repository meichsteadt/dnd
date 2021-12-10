class Alignment
  include Mongoid::Document
  store_in collection: "alignments"
  field :index, type: String
	field :name, type: String
	field :abbreviation, type: String
	field :desc, type: String
	field :url, type: String
end