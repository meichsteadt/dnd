class RuleSection
  include Mongoid::Document
  store_in collection: "rule-sections"
  field :name, type: String
	field :index, type: String
	field :desc, type: String
	field :url, type: String
end