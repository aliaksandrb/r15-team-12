$(document).on 'page:change', ->
  window.QF = window.QF || {}

  $stage = $('.stage')
  $defaultStageWidth = $stage.width()

  heroes = {
    guy: $('.hero-guy').data('flipped', false)
  }

  actions = {
    walk: (hero)->
      hero.addClass('walk')

    walkRight: (hero, value, way = 0) ->
      moving = setTimeout( ->
       hero.addClass('walk').css({ marginLeft: '+=10px' })
       way += 10
       if way < value
         actions.walkRight(hero, value, way)
       else
         actions.stop(hero)
      , 100)

    walkLeft: (hero) ->
      hero.addClass('walk').css({ marginLeft: '-=10px' })

    walkFromLeftToCenter: (hero, way = 0) ->
      moving = setTimeout( ->
        actions.walkRight(hero)
        way += 10
        if way < ($defaultStageWidth / 2 - hero.width())
          actions.walkFromLeftToCenter(hero, way)
        else
          actions.stop(hero)
      , 100)

    walkFromCenterToLeft: (hero, way = 0) ->
      actions.flip(hero)

      moving = setTimeout( ->
        actions.walkLeft(hero)
        way += 10
        if way < ($defaultStageWidth / 2 - hero.width())
          actions.walkFromCenterToLeft(hero, way)
        else
          actions.stop(hero)
          actions.unflip(hero)
      , 100)

    flip: (hero) ->
      hero.addClass('flip')
      hero.data('flipped', true)

    unflip: (hero) ->
      hero.removeClass('flip')
      hero.data('flipped', false)

    stop: (hero) ->
      hero.removeClass('walk')
      hero.removeClass('punch')
      hero.removeClass('win')
      hero.removeClass('low_punch')
      hero.removeClass('jump')
      hero.removeClass('hurt')
      hero.removeClass('die')
      hero.removeClass('fatality')

    punch: (hero) ->
      hero.addClass('punch')

    win: (hero) ->
      hero.addClass('win')

    low_punch: (hero) ->
      hero.addClass('low_punch')

    jump: (hero) ->
      hero.addClass('jump')

    hurt: (hero) ->
      hero.addClass('hurt')

    die: (hero) ->
      hero.addClass('die')

    fatality: (hero) ->
      hero.addClass('fatality')
  }

  animate_hero_step = (action, value, hero) ->
    actions.stop(hero)
    action(hero, value || 0)

  procced_hero_step = (step, direction) ->
    console.log 'procced_hero_step'

    if direction == 'left'
      hero = heroes.guy
    else
      hero = 'computer'

    action = step[0]
    switch action
      when 'walk'
        animate_hero_step(actions['walkRight'], step[1], hero)
      else
        animate_hero_step(actions[action], step[1], hero)

  steps_manager = (hero_steps, direction, callback) ->
    if direction == 'left'
      hero = heroes.guy
    else
      hero = 'computer'

    if hero_steps.length > 0
      setTimeout( ->
        procced_hero_step(hero_steps.shift(), direction)
        steps_manager(hero_steps, direction, callback)
      , 300)
    else
      actions.stop(hero)
      callback()

  parse_answer_response = (data_json, callback) ->
    console.log data_json

    if data_json.game_status == 'round'
      hero_left_steps = data_json.steps[0]
      hero_right_steps = data_json.steps[1]

      steps_manager(hero_left_steps, 'left', callback)
    else
      console.log('die')
      callback()

  window.QF.heroes = $.extend(window.QF.heroes, heroes)
  window.QF.actions = $.extend(window.QF.actions, actions)
  window.QF.parse_answer_response = parse_answer_response

