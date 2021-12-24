class Character
  include Mongoid::Document
  store_in collection: "characters"
  field :user_id, type: Integer
  field :index, type: String
  field :character_class, type: CharacterClass
	field :name, type: String
	field :race, type: Race
	field :size, type: String
	field :alignment, type: Alignment
	field :current_health, type: Integer
	field :initiative, type: Integer
	field :armor_class, type: Integer
	field :hit_points, type: Integer
	field :hit_dice, type: String
	field :speed, type: Hash
	field :strength, type: Integer
	field :dexterity, type: Integer
	field :constitution, type: Integer
	field :intelligence, type: Integer
	field :wisdom, type: Integer
	field :charisma, type: Integer
	field :proficiencies, type: Array
	field :damage_vulnerabilities, type: Array
	field :damage_resistances, type: Array
	field :damage_immunities, type: Array
	field :condition_immunities, type: Array
	field :senses, type: Hash
	field :languages, type: String
	field :special_abilities, type: Array
	field :actions, type: Array
	field :_type, type: String

  def player_name
    User.find(self.user_id).email
  end

  def character_info
    "#{self.size} #{self.type} (#{self.subtype}), #{self.alignment}".gsub(" ()", "")
  end

  def roll_for_initiative
    self.initiative = Random.rand(20) + 1
  end

  def get_health
    self.current_health.nil? ? 0 : self.current_health
  end


  def parsed_spellcasting
    desc = self.special_abilities.find {|e| e["name"] == "Spellcasting"}["desc"]
    spell_texts = desc.split("\n-")[1..-1]
    after_asterisk = nil

    spell_texts.each do |text|
      spell_names = text.split(": ")[-1].split(", ")
      spells_with_html = spell_names.map do |spell_name|
        # Handles spells with an asterisk like on ArchMage
        asterisk_split = spell_name.downcase.split("*")
        after_asterisk = asterisk_split.last
        parsed_spell_name = asterisk_split.first.strip
        regex = Regexp.new(parsed_spell_name, true)
        spell = Spell.find_by(name: regex)

        if spell_name =~ /\*/ && asterisk_split.count > 1
          "<span class='spell' id=#{spell.id} data-id='#{spell.id}'>#{spell.name.downcase}*</span><br><br>*<em>#{after_asterisk}</em>"
        elsif spell_name =~ /\*/
          "<span class='spell' id=#{spell.id} data-id='#{spell.id}'>#{spell.name.downcase}*</span>"
        else
          "<span class='spell' id=#{spell.id} data-id='#{spell.id}'>#{spell.name.downcase}</span>"
        end
      end
      desc = desc.gsub(spell_names.join(", "), spells_with_html.join(", "))
    end
    desc
  end

  def spells
    _spells = self.special_abilities.find {|e| e["name"] == "Spellcasting"}["spellcasting"]["spells"]
  end

  def get_spells_by_level(level)
    if level == 'Cantrip'
      level = 0
    elsif level.class == String
      level = level.match(/\d/).to_s.to_i
    end
    self.spells.filter {|e| e["level"] == level}
  end

  def find_spell(name)
    spells.find {|e| e["name"].downcase == name.downcase}
  end

  def challenge
    if self.challenge_rating < 1 && self.challenge_rating > 0
      self.challenge_rating.to_r.to_s
    else
      self.challenge_rating.round
    end
  end

  def parse_senses
    self.senses.map do |k,v|
      name = k.gsub('_', ' ').capitalize
      value = v
      "#{name} #{value}"
    end.join(", ")
  end

  def parse_proficiencies
    # Returns a ProficiencyGroup Array
    proficiency_groups = []
    _proficiencies = self.proficiencies.each do |prof|
      prof_type, prof_name = prof["proficiency"]["name"].split(": ")
      proficiency = Proficiency.new(prof_type, prof_name, prof["value"])

      group = proficiency_groups.find {|e| e.type == proficiency.type}
      if group
        group.proficiencies << proficiency
      else
        proficiency_groups << ProficiencyGroup.new(proficiency.type, [proficiency])
      end
    end
    proficiency_groups.sort_by {|e| e.type}
  end

  def set_character_class(id)
    self.character_class = CharacterClass.find(id)
  end

  def set_alignment(id)
    self.alignment = Alignment.find(id)
  end

  def set_race(id)
    self.race = Race.find(id)
  end


  #===============================   Shortcuts for form  ==============================
  def ability_score_fields
    %i[strength dexterity constitution intelligence charisma wisdom]
  end

  def drop_downs
    %i[character_class race alignment].map {|e| DropDownField.new(e)}
  end

  def class_specific
    {
      drop_downs: %i[level].map {|e| DropDownField.new(e)},
      proficiencies: character_class.map_proficiency_choices
    }
  end

  #===============================   Mongo  ===============================

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

Proficiency = Struct.new(:type, :name, :value) do
  def to_s
    "#{self.name} +#{self.value}"
  end
end
ProficiencyGroup = Struct.new(:type, :proficiencies) do
  def parse_proficiencies
    self.proficiencies.map(&:to_s).join(", ")
  end
end
DropDownField = Struct.new(:field_name) do
  def all
    const = field_name.to_s.camelize.constantize
    const.all.order(name: :asc)
  end

  def where(**params)
    const = field_name.to_s.camelize.constantize
    const.where(params)
  end

  def split_name
    self.field_name.to_s.split("_").join(" ").capitalize
  end

  def selected(character)
    character[self.field_name]._id.to_s if character[self.field_name]
  end
end
