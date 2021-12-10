json.extract! monster, :id, :name, :hit_points, :challenge, :challenge_rating, :xp
json.url monster_url(monster, format: :json)
