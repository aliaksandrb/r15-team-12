$(document).on 'ready page:load', ->
  links = $('.add-more-options-link')
  links.on('click', (e) ->
    e.preventDefault()

    number = $(this).data('number')
    options = $(this).closest('.answer-options').find('.form-control:last')
    option_number = options.find('input.form-control').size() + 1

    options.after(
      '<br><input class="form-control" type="string" value="" label="Option ' + option_number + ': " name="quiz[questions_attributes][' + number + '][options][]" id="quiz_questions_attributes_' + number + '_">'
    )

    next = $(this).closest('.form-inputs').find('span').size() + 1

    $(this).closest('.form-inputs').find('span:last').after(
     '<span><label for="quiz_questions_attributes_' + number + '_answer_' + next + '">' +
     '<label style="color:black; margin: 5px" for="quiz_questions_attributes_' + number + '_answer_' + next + '">' + next + '</label>' +
     '<input type="radio" value="' + next + '" checked="checked" name="quiz[questions_attributes][' + number + '][answer]" id="quiz_questions_attributes_' + number + '_answer_' + next + '">' +
     '</label></span>'
    )
  )
