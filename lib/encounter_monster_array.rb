class EncounterMonsterArray < Array
  attr_reader :encounter_monsters

  def mongoize
    self.map(&:mongoize)
  end

  def self.demongoize(object)
    object ? object.map {|e| EncounterMonster.demongoize(e)} : new
  end

  # Takes any possible object and converts it to how it would be
  # stored in the database.
  def self.mongoize(object)
    case object
    when EncounterMonsterArray then object.mongoize
    when Hash then EncounterMonsterArray[object].mongoize
    else object
    end
  end

  # Converts the object that was supplied to a criteria and converts it
  # into a database friendly form.
  def self.evolve(object)
    case object
      when EncounterMonsterArray then object.mongoize
      else object
    end
  end
end
