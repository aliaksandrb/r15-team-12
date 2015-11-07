$(document).on 'ready page:load', ->
  links = $('.add-more-options-link')
  links.on('click', (e) ->
    e.preventDefault()

    number = $(this).data('number')
    options = $(this).closest('.answer-options')
    option_number = options.find('input.form-control').size() + 1

    options.find('.form-group').after(
      '<input class="form-control" type="string" value="" label="Option ' + option_number + ': " name="quiz[questions_attributes][' + number + '][options][]" id="quiz_questions_attributes_' + number + '_"><br>'
    )
  )
