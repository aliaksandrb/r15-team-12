class Question < ActiveRecord::Base
  belongs_to :quiz

  PLAYER_WIN = 'player_win'.freeze
  QUIZ_WIN = 'quize_win'.freeze
  TIMEOUT = 'timeout'.freeze
end

# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  quiz_id    :integer          not null
#  text       :string           not null
#  answer     :integer          not null
#  time_limit :integer          default(30), not null
#  options    :hstore           default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#
