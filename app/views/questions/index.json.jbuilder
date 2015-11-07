json.array!(@questions) do |question|
  json.extract! question, :id, :text, :answer, :time_limit, :options
  json.url question_url(question, format: :json)
end
