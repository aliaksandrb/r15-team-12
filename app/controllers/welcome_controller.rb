class WelcomeController < ApplicationController
  def index
    @recent_quizzes = Quiz.order(created_at: :desc).last(6)
  end
end
