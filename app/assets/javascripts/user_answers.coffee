$(document).on 'ready page:load', ->
  $('#new_user_answer').on('ajax:success', (e, data, status, xhr) ->
    console.log data
  )
