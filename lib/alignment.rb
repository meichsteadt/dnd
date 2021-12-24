class Alignment
  include Mongoid::Document
  store_in collection: "alignments"
  field :index, type: String
	field :name, type: String
	field :abbreviation, type: String
	field :desc, type: String
	field :url, type: String

  def mongoize
    self.attributes
  end

  def self.demongoize(object)
    Alignment.new(object)
  end

  # Takes any possible object and converts it to how it would be
  # stored in the database.
  def self.mongoize(object)
    case object
    when Alignment then object.mongoize
    when Hash then Alignment.new(object).mongoize
    else object
    end
  end

  # Converts the object that was supplied to a criteria and converts it
  # into a database friendly form.
  def self.evolve(object)
    case object
    when Alignment then object.mongoize
    else object
    end
  end
end
