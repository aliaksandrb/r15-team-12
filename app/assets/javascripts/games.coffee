$(document).on 'ready page:load', ->
  $('#question-modal').modal()

  $('#sumbit-answer-btn').on('click', (e) ->
    e.preventDefault()

    $('#new_user_answer').submit()
  )

