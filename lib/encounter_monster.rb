class EncounterMonster
  include Mongoid::Document
  store_in collection: "encounter_monsters"
  field :monster
  field :current_health, type: Integer
  field :initiative, type: Integer
  field :loot_items, type: Array
  field :loot_currency, type: Currency

  def loot
    Loot.new(self.loot_items, self.loot_currency)
  end

  def monster
    Monster.new(self.monster_data)
  end

  def mongoize
    self.attributes
  end

  def self.demongoize(object)
    EncounterMonster.new(object)
  end

  # Takes any possible object and converts it to how it would be
  # stored in the database.
  def self.mongoize(object)
    case object
    when EncounterMonster then object.mongoize
    when Hash then EncounterMonster.new(object).mongoize
    else object
    end
  end

  # Converts the object that was supplied to a criteria and converts it
  # into a database friendly form.
  def self.evolve(object)
    case object
    when EncounterMonster then object.mongoize
    else object
    end
  end
end
Loot = Struct.new(:items, :currency)
