class UserAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :game
end

# == Schema Information
#
# Table name: user_answers
#
#  id          :integer          not null, primary key
#  question_id :integer
#  value       :integer          not null
#  game_id     :integer
#  timeout     :integer          default(30), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_answers_on_game_id      (game_id)
#  index_user_answers_on_question_id  (question_id)
#
