class Encounter
  include Mongoid::Document
  store_in collection: "encounters"
  field :name, type: String
  field :index, type: String
  field :monsters, type: EncounterMonsterArray
  field :npcs, type: EncounterMonsterArray
  field :characters, type: CharacterArray
  field :initiatives, type: Array
  field :notes, type: String
  field :player_level, type: Integer
  field :n_players, type: Integer
  field :started, type: Boolean

  def find_monster(id)
    self.monsters.filter {|e| e._id.to_s == id}.first
  end

  def find_character(id)
    self.characters.filter {|e| e._id.to_s == id}.first
  end

  def find_npc(id)
    self.npcs.filter {|e| e._id.to_s == id}.first
  end

  def reset
    _monsters = self.monsters
    __monsters ||= []
    monster_map = _monsters.map do |monster|
      monster.initiative = nil;
      monster.current_health = monster.monster.hit_points;
      monster
    end
    _npcs = self.npcs
    __npcs ||= []
    npc_map = _npcs.map do |npc|
      npc.initiative = nil;
      npc.current_health = npc.monster.hit_points;
      npc
    end
    _characters = self.characters
    __characters ||= []
    character_map = _characters.map do |character|
      _character = Character.find(character.id)
      _character.initiative = nil;
      _character.save
    end
    self.update(monsters: EncounterMonsterArray[*monster_map], characters: CharacterArray[*character_map],npcs: EncounterMonsterArray[*npc_map], started: true)
  end

  def encounter_characters
    (monsters.to_a + characters.to_a + npcs.to_a).sort_by {|e| e["initiative"] ? -(e["initiative"]) : 0}
  end

  def add_characters(*characters)
    self.characters = CharacterArray[*Array[characters].flatten + self.characters]
    self.save
  end

  def remove_characters(*characters)
    self.characters = CharacterArray[*self.characters - Array[characters].flatten]
    self.save
  end

  def self.challenge_table
    { '1' => [25, 50, 75, 100],
      '2' => [50, 100, 150, 200],
      '3' => [75, 150, 225, 400],
      '4' => [125, 250, 375, 500],
      '5' => [250, 500, 750, 1100],
      '6' => [300, 600, 900, 1400],
      '7' => [350, 750, 1100, 1700],
      '8' => [450, 900, 1400, 2100],
      '9' => [550, 1100, 1600, 2400],
      '10' => [600, 1200, 1900, 2800],
      '11' => [800, 1600, 2400, 3600],
      '12' => [1000, 2000, 3000, 4500],
      '13' => [1100, 2200, 3400, 5100],
      '14' => [1250, 2500, 3800, 5700],
      '15' => [1400, 2800, 4300, 6400],
      '16' => [1600, 3200, 4800, 7200],
      '17' => [2000, 3900, 5900, 8800],
      '18' => [2100, 4200, 6300, 9500],
      '19' => [2400, 4900, 7300, 10900],
      '20' => [2800, 5700, 8500, 12700]
    }.map {|k,v| ChallengeRow.new(k.to_i, *v)}
  end

  def self.scale_challenge(n)
    case n
    when 1
      1
    when 2
      1.5
    when 3..6
      2
    when 7..10
    2.5
    when 11..14
      3
    when 15..Float::INFINITY
      4
    end
  end

  def self.get_difficulty(**params)
    n_players = params[:n_players].to_i
    player_level = params[:player_level].to_i
    total_xp = params[:total_xp].to_i
    n_monsters = params[:n_monsters].to_i

    scaled_xp = total_xp * scale_challenge(n_monsters) / n_players
    challenge_table.find {|e| e.lvl == player_level}.difficulty(scaled_xp)
  end
end

ChallengeRow = Struct.new(:lvl, :easy, :medium, :hard, :deadly) do
  def difficulty(xp)
    case xp
    when 0..easy
      'Easy'
    when easy..medium
      'Medium'
    when medium..hard
      'Hard'
    when hard..Float::INFINITY
      'Deadly'
    end
  end
end
