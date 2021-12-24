class CharacterClass
  include Mongoid::Document
  store_in collection: "classes"
  field :index, type: String
	field :name, type: String
	field :hit_die, type: Integer
	field :proficiency_choices, type: Array
	field :proficiencies, type: Array
	field :saving_throws, type: Array
	field :starting_equipment, type: Array
	field :starting_equipment_options, type: Array
	field :class_levels, type: String
	field :spellcasting, type: Hash
	field :spells, type: String
	field :multi_classing, type: Hash
	field :subclasses, type: Array
	field :url, type: String

  def map_proficiency_choices
    self.proficiency_choices.first["from"].map {|e| [e["index"], e["name"].gsub("Skill: ", "")]}
  end

  def mongoize
    self.attributes
  end

  def self.demongoize(object)
    CharacterClass.new(object)
  end

  # Takes any possible object and converts it to how it would be
  # stored in the database.
  def self.mongoize(object)
    case object
    when CharacterClass then object.mongoize
    when Hash then CharacterClass.new(object).mongoize
    else object
    end
  end

  # Converts the object that was supplied to a criteria and converts it
  # into a database friendly form.
  def self.evolve(object)
    case object
    when CharacterClass then object.mongoize
    else object
    end
  end
end
