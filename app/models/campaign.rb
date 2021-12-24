class Campaign < ApplicationRecord
  validates :name, presence: true, uniqueness: {scope: :user_id}
  validates :room, uniqueness: true
  before_create :create_room_hash

  belongs_to :user
  has_many :books
  has_many :chapters, through: :books
  has_many :pages, through: :chapters
  include HTMLParser

  def html
    self.notes
  end

  def get_active_display_partial
    _class = self.active_display.keys[0]
    case _class
    when 'Encounter'
      './encounters/encounter_readonly'
    when 'Map'
      './maps/map'
    else
      ''
    end
  end

  def get_active_display_hash
    _instance_variable = self.active_display.keys[0].underscore
    {"#{_instance_variable}".to_sym => get_active_display}
  end

  def first_book
    book = self.books.order(:order).first
    book ||= self.books.new
  end

  def create_room_hash
    room = SecureRandom.hex(3)
    hashes = Campaign.pluck(:room)

    while hashes.include?(room)
      room = SecureRandom.hex(3)
    end
    self.room = room
  end

  def get_players
    Character.where(id: { :$in => self.players.uniq })
  end

  def add_player(id)
    self.players << id
    self.players.uniq!
    self.save
  end

  def remove_player(id)
    self.players.delete(id)
    self.save
    # RoomsChannel.broadcast_to(self, self.get_players)
  end

  def set_active_display(object)
    self.update(active_display: Hash[object.class.to_s, object.id.to_s])
  end

  def get_active_display
    k, v = self.active_display.to_a.flatten
    return if k.nil? || v.nil?
    k.constantize.find(v)
  end
end
