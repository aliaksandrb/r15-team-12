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

    walkRight: (hero) ->
      hero.addClass('walk').css({ marginLeft: '+=10px' })

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

    punch: (hero) ->
      hero.addClass('punch')

    win: (hero) ->
      hero.addClass('win')

    low_punch: (hero) ->
      hero.addClass('low_punch')

  }

  window.QF.heroes = $.extend(window.QF.heroes, heroes)
  window.QF.actions = $.extend(window.QF.actions, actions)

