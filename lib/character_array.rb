class CharacterArray < Array
  attr_reader :characters

  def find(id)
    self.characters.find_by {|e| e._id.to_s == id}
  end

  def mongoize
    self.map(&:mongoize)
  end

  def self.demongoize(object)
    object ? object.map {|e| Character.demongoize(e)} : new
  end

  # Takes any possible object and converts it to how it would be
  # stored in the database.
  def self.mongoize(object)
    case object
    when CharacterArray then object.mongoize
    when Hash then CharacterArray[object].mongoize
    else object
    end
  end

  # Converts the object that was supplied to a criteria and converts it
  # into a database friendly form.
  def self.evolve(object)
    case object
    when CharacterArray then object.mongoize
      else object
    end
  end
end
