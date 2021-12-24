class Npc < Monster
  def self.hidden_attributes
    [:proficiencies, :senses, :xp, :challenge_rating, :type, :hit_dice, :actions, :legendary_actions, :special_abilities, :damage_immunities, :damage_vulnerabilities, :damage_resistances, :condition_immunities, :special_abilities, :type, :speed, :languages, :reactions]
  end

  def self.not_accepted_keys
    [:_id, :id, :index, :url, :user_id, :_type, :base]
  end

  def self.accepted_keys
    fields = (not_accepted_keys)
    [:base, :name] + Monster.fields.keys.to_a.filter {|e| !fields.include?(e.to_sym) }.map(&:to_sym)

  end

  def self.ability_score_fields
    %i[strength dexterity constitution intelligence charisma wisdom]
  end

  def self.subtypes
    (Race.pluck(:name).uniq + Monster.pluck(:type)).uniq.reject(&:nil?).map {|e| [e.capitalize, e.downcase] if e}.sort_by {|e| e[0] if e}
  end
end
