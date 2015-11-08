json.array!(@quizzes) do |quiz|
  json.extract! quiz, :id, :name, :fail_limit, :author_email, :description
  json.url quiz_url(quiz, format: :json)
end
