class Race
  include Mongoid::Document
  store_in collection: "races"
  field :index, type: String
	field :name, type: String
	field :speed, type: Integer
	field :ability_bonuses, type: Array
	field :alignment, type: String
	field :age, type: String
	field :size, type: String
	field :size_description, type: String
	field :starting_proficiencies, type: Array
	field :starting_proficiency_options, type: Hash
	field :languages, type: Array
	field :language_options, type: Hash
	field :language_desc, type: String
	field :traits, type: Array
	field :subraces, type: Array
	field :ability_bonus_options, type: Hash
	field :url, type: String

  def mongoize
    self.attributes
  end

  def self.demongoize(object)
    Race.new(object)
  end

  # Takes any possible object and converts it to how it would be
  # stored in the database.
  def self.mongoize(object)
    case object
    when Race then object.mongoize
    when Hash then Race.new(object).mongoize
    else object
    end
  end

  # Converts the object that was supplied to a criteria and converts it
  # into a database friendly form.
  def self.evolve(object)
    case object
    when Race then object.mongoize
    else object
    end
  end
end
