class Map
  include Mongoid::Document
  store_in collection: "maps"
	field :name, type: String
	field :user_id, type: Integer
	field :preview, type: String
	field :ink_id, type: String
end
