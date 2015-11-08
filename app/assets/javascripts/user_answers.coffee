$(document).on 'ready page:load', ->
  $('#new_user_answer').on('ajax:success', (e, data, status, xhr) ->
    $('#question-modal').modal('hide')

    QF.parse_answer_response(data, ->
      $.ajax({
        url: document.location.pathname,
        method: 'GET',
        dataType: 'script',
      }).done((data, status, xhr) ->
        $('#question-modal').modal()
      )
    )
  )

