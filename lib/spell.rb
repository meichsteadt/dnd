class Spell
  include Mongoid::Document
  store_in collection: "spells"
  field :index, type: String
	field :name, type: String
	field :desc, type: Array
	field :higher_level, type: Array
	field :range, type: String
	field :components, type: Array
	field :material, type: String
	field :ritual, type: FalseClass
	field :duration, type: String
	field :concentration, type: FalseClass
	field :casting_time, type: String
	field :level, type: Integer
	field :attack_type, type: String
	field :damage, type: Hash
	field :school, type: Hash
	field :classes, type: Array
	field :subclasses, type: Array
	field :url, type: String

  def meta_info
    if self.level == 0
      return "#{self.school['name']} Cantrip"
    else
      return "#{self.level.ordinalize} level #{self.school['name']}"
    end
  end
end
