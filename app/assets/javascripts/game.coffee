$(document).on 'page:change', ->
  window.QF = window.QF || {}

  # guy - player
  # neptune - computer

  heroes = {
    guy: $('.hero-guy').data('flipped', false)
    neptune: $('.hero-neptune')
  }

  stage = $('.stage')
  defaultStageWidth = stage.width()
  heroWidth = 250

  localStorage.removeItem('distanceBettweenHeroes')

  current_distance = ->
    if localStorage.getItem('distanceBettweenHeroes') && !isNaN(localStorage.getItem('distanceBettweenHeroes'))
      Number(localStorage.getItem('distanceBettweenHeroes'))
    else
      defaultStageWidth - heroWidth * 2

  update_distance = (value) ->
    localStorage.setItem('distanceBettweenHeroes', current_distance() + value)

  update_distance((defaultStageWidth - heroWidth * 2) / 2)

  styles = {
    walk: (hero) ->
      hero.addClass('walk') unless hero.hasClass('walk')

    punch: (hero) ->
      hero.addClass('punch') unless hero.hasClass('punch')

    win: (hero) ->
      hero.addClass('win') unless hero.hasClass('win')

    low_punch: (hero) ->
      hero.addClass('low_punch') unless hero.hasClass('low_punch')

    jump: (hero) ->
      hero.addClass('jump') unless hero.hasClass('jump')

    hurt: (hero) ->
      hero.addClass('hurt') unless hero.hasClass('hurt')

    die: (hero) ->
      hero.addClass('die') unless hero.hasClass('die')

    fatality: (hero) ->
      hero.addClass('fatality') unless hero.hasClass('fatality')

    flip: (hero) ->
      hero.addClass('flip') unless hero.hasClass('flip')
      hero.data('flipped', true)

    unflip: (hero) ->
      hero.removeClass('flip') if hero.hasClass('flip')
      hero.data('flipped', false)
  }

  stop = (hero, timeout = 300) ->
    setTimeout( ->
      hero.removeClass('walk')
      hero.removeClass('punch')
      hero.removeClass('win')
      hero.removeClass('low_punch')
      hero.removeClass('jump')
      hero.removeClass('hurt')
      hero.removeClass('die')
      hero.removeClass('fatality')
    , timeout)

  move = (hero, value_in_per, dir = 'left') ->
    diff = (defaultStageWidth / 100) * value_in_per

    if dir == 'left'
      hero.css({ marginLeft: '+=' + diff + 'px' })
    else
      hero.css({ marginRight: '+=' + diff + 'px' })

    update_distance(0 - diff)

  update_health = (value, dir = 'left') ->
    bar = $('.' + dir + '-stage-health .progress-bar')
    bar.attr('aria-valuenow', value).css('width', value + '%');

  actions = {
    walk: (hero, value, dir = 'left') ->
      styles.walk(hero)
      move(hero, value, dir)
      stop(hero)

    punch: (hero, value = 0, dir = 'left') ->
      styles.punch(hero)
      stop(hero)

    win: (hero, value = 0, dir = 'left') ->
      styles.win(hero)
      stop(hero, 5000)

    low_punch: (hero, value = 0, dir = 'left') ->
      styles.low_punch(hero)
      stop(hero)

    jump: (hero, value, dir = 'left') ->
      styles.jump(hero)
      move(hero, value, dir)
      stop(hero)

    hurt: (hero, value, dir = 'left') ->
      styles.hurt(hero)
      update_health(value, dir)
      stop(hero)

    die: (hero, value = 0, dir = 'left') ->
      styles.die(hero)
      stop(hero)

    fatality: (hero, value = 0, dir = 'left') ->
      styles.fatality(hero)
      stop(hero, 1000)

  steps_manager = (hero_step, direction) ->
    if direction == 'left'
      hero = heroes.guy
    else
      hero = heroes.neptune

    action = hero_step[0]
    value = hero_step[1]

    actions[action](hero, value, direction)

 # synhronize steps to show
  procced_steps = (all_steps, callback) ->
    if all_steps.length > 0
       setTimeout( ->
         step = all_steps.shift()

         steps_manager(step[0], 'left')
         steps_manager(step[1], 'right')

         procced_steps(all_steps, callback)
       , 500)
     else
       stop(heroes.guy)
       stop(heroes.neptune)
       callback() if callback

  # response parser
  parse_answer_response = (data_json, callback) ->
    if data_json.game_status == 'round'
      all_steps = data_json.steps

      procced_steps(all_steps, callback)
    else
      alert('END GAME')
      # play fatality here
      callback() if callback


  window.QF.heroes = $.extend(window.QF.heroes, heroes)
  window.QF.actions = $.extend(window.QF.actions, actions)
  window.QF.styles = $.extend(window.QF.styles, styles)
  window.QF.parse_answer_response = parse_answer_response

