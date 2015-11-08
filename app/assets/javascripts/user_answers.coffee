$(document).on 'ready page:load', ->
  $('#new_user_answer').on('ajax:success', (e, data, status, xhr) ->
    QF.parse_answer_response(data, ->
      $.ajax({
        url: document.location.pathname,
        method: 'GET',
        dataType: 'script',
      }).done((data, status, xhr) ->
        console.log data
      )
    )
  )

