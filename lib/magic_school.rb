class MagicSchool
  include Mongoid::Document
  store_in collection: "magic-schools"
  field :index, type: String
	field :name, type: String
	field :desc, type: String
	field :url, type: String
end