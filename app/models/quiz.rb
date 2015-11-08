class Quiz < ActiveRecord::Base
  NUMBER_OF_QUESIONS = 5

  has_many :questions
  has_many :games

  validates :fail_limit, inclusion: { in: 0...NUMBER_OF_QUESIONS,
                                      message: "Give a chance to the quiz, fail limit 0..#{NUMBER_OF_QUESIONS-1}"}

  accepts_nested_attributes_for :questions, allow_destroy: true, limit: NUMBER_OF_QUESIONS
end

# == Schema Information
#
# Table name: quizzes
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  fail_limit   :integer          default(0), not null
#  author_email :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
