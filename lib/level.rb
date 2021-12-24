class Level
  include Mongoid::Document
  store_in collection: "levels"
  field :level, type: Integer
	field :ability_score_bonuses, type: Integer
	field :prof_bonus, type: Integer
	field :features, type: Array
	field :class_specific, type: Hash
	field :index, type: String
	field :character_class, type: Hash
	field :url, type: String

  def name
    self.level
  end
end
