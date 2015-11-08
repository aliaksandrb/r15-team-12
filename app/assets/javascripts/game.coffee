$(document).on 'page:change', ->
  window.QF = window.QF || {}

  heroes = {
    guy: {
      class: '.hero-guy',
    }
  }

  actions = {
    walk: (hero) ->
      hero.addClass('walk')
    stop: (hero) ->
      hero.removeClass('walk')
  }

  window.QF.heroes = $.extend(window.QF.heroes, heroes)
  window.QF.actions = $.extend(window.QF.heroes, heroes)

