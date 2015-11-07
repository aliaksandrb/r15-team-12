class Game < ActiveRecord::Base
  validates_format_of :player_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  FINISHED = 'finished'.freeze
  ROUND = 'round'.freeze
  MAX_HEALTH = 100
end



# == Schema Information
#
# Table name: games
#
#  id            :integer          not null, primary key
#  player_email  :string           not null
#  game_time     :integer          not null
#  quiz_health   :integer          not null
#  player_health :integer          not null
#  quiz_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_games_on_quiz_id  (quiz_id)
#
