json.extract! player, :id, :name, :class, :character_sheet_url, :user_id, :health, :created_at, :updated_at
json.url player_url(player, format: :json)
