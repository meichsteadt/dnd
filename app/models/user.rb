class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :campaigns
  has_many :books, through: :campaigns
  has_many :chapters, through: :books

  def characters
    Character.where(user_id: self.id)
  end

  def npcs
    Npc.where(user_id: self.id)
  end
end
