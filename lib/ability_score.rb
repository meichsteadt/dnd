class AbilityScore
  include Mongoid::Document
  store_in collection: "ability-scores"
  field :index, type: String
	field :name, type: String
	field :full_name, type: String
	field :desc, type: Array
	field :skills, type: Array
	field :url, type: String

  def mongoize
    self.attributes
  end

  def self.demongoize(object)
    Character.new(object)
  end

  # Takes any possible object and converts it to how it would be
  # stored in the database.
  def self.mongoize(object)
    case object
    when Character then object.mongoize
    when Hash then Character.new(object).mongoize
    else object
    end
  end

  # Converts the object that was supplied to a criteria and converts it
  # into a database friendly form.
  def self.evolve(object)
    case object
    when Character then object.mongoize
    else object
    end
  end
end
