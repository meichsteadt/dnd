class EncounterMonster
  include Mongoid::Document
  store_in collection: "encounter_monsters"
  field :index, type: String
  field :monster, type: Monster
  field :current_health, type: Integer
  field :initiative, type: Integer
  field :loot_items, type: Array
  field :loot_currency, type: Currency
  field :_type, type: String

  def loot
    Loot.new(self.loot_items, self.loot_currency)
  end

  def get_health
    self.current_health.nil? ? 0 : self.current_health
  end

  def roll_for_initiative
    self.initiative = Random.rand(20) + 1
  end

  def name
    self.monster.name
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
