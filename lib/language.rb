class Language
  include Mongoid::Document
  store_in collection: "languages"
  field :index, type: String
	field :name, type: String
	field :type, type: String
	field :typical_speakers, type: Array
	field :script, type: String
	field :url, type: String
end