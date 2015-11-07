json.array!(@games) do |game|
  json.extract! game, :id, :player_email, :game_time, :quiz_health, :player_health, :quiz_id
  json.url game_url(game, format: :json)
end
