json.array!(@quizzes) do |quiz|
  json.extract! quiz, :id, :name, :fail_limit, :author_email
  json.url quiz_url(quiz, format: :json)
end
