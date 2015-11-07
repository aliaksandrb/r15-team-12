class Quiz < ActiveRecord::Base
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
