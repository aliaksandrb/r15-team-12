class Quiz < ActiveRecord::Base
  has_many :questions
  has_many :games
  accepts_nested_attributes_for :questions, allow_destroy: true, limit: 3
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
