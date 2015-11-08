
module StepGenerator
  # Assume player is always on left

  def generate(game, question, answer)
    healths = { player: { start: game.player_health, final: 0 },
               quiz:   { start: game.quiz_health,   final: 0}}

    $rand = Random.new(Time.now.to_i)
    steps = []
    # [[[left_action, value],[right_action, value]],
    #  [[left_action, value],[right_action, value]],
    #  [[left_action, value],[right_action, value]]]

    if timeouted?(game, answer)
      game_status = Question::TIMEOUT
    else
      question_status = correct?(answer, question) ? Question::PLAYER_WIN : Question::QUIZ_WIN
      healths = calc_health(game, question_status)
      game_status = finished?(healths) ? Game::FINISHED : Game::ROUND

      steps = case [game_status, question_status]
              when [Game::FINISHED, Question::PLAYER_WIN]   then fatality_based_win healths, :left
              when [Game::FINISHED, Question::QUIZ_WIN]     then fatality_based_win healths
              when [Game::ROUND,    Question::PLAYER_WIN]   then dominate_fight healths, :left
              when [Game::ROUND,    Question::QUIZ_WIN]     then dominate_fight healths
              end
    end
    # Format
    # { game_status: Status::Game::ROUND,
    #  question_status: Status::Question::QUIZ_WIN,
    #  player_health: 50,
    #  quiz_health: 75,
    #  steps: [[[left_action, value],[right_action, value]],
    #          [[left_action, value],[right_action, value]],
    #          [[left_action, value],[right_action, value]]] }
    #
     { game_status: game_status,
       question_status: question_status,
       player_health: healths[:player][:final],
       quiz_health: healths[:quiz][:final],
       steps: steps
     }
  end

  def timeouted?(game, answer)
    return false
    # TODO check timeout
    answer.timeout - game.game_time > answer.question.time_limit * 1.1
  end

  def correct?(answer, question)
    question.answer == answer.value
  end

  def calc_health(game, question_status)
    healths = { player: { start: game.player_health, final: 0 },
               quiz:   { start: game.quiz_health,   final: 0}}

    if question_status == Question::PLAYER_WIN
      healths[:quiz][:final] = healths[:quiz][:start] - (Game::MAX_HEALTH / (game.quiz.questions.size - game.quiz.fail_limit) + 1)
    else
      healths[:player][:final] = healths[:player][:start] - (Game::MAX_HEALTH / (game.quiz.fail_limit + 1) + 1)
    end

    healths
  end

  def finished?(healths)
    healths[:player][:final] <= 0 || healths[:quiz][:final] <= 0
  end

  # Possible actions
  # walk, jump : value [direction and length]
  # hurt, die : value [player health change]
  # punch, low_punch, fatality, stop, hide, flip, win : value [null]

  MOVEMENT = ['walk', 'jump']
  ATTACK = ['punch', 'low_punch']
  SUPER_ATTACK = ['fatality']

  def dominate_fight(healths, left_lead = false)
    result = []
    pos = fight_movement_steps(4)
    hurts = damage(healths, left_lead)


    result << [ move(pos[0][0]),      move(pos[0][1]) ]
    result << [ move(pos[1][0]),      move(pos[1][1]) ]
    result << [ attack,               hurt(hurts[0]) ]
    result << [ retreet(pos[2][0]),   move(pos[2][1]) ]
    result << [ attack,               attack ]
    result << [ move(pos[3][0]),      move(pos[3][1]) ]
    result << [ blocked_attack ]
    result << [ attack,               hurt(hurts[1]) ]

    result.map!{ |r| r[0], r[1] = r[1], r[0] } unless left_lead
    result
  end

  def fatality_based_win(healths, left_lead = false)
    result = []
    pos = fight_movement_steps(4)
    hurts = damage(healths, left_lead)


    result << [ move(pos[0][0]),      move(pos[0][1]) ]
    result << [ move(pos[1][0]),      move(pos[1][1]) ]
    result << [ attack,               hurt(hurts[0]) ]
    result << [ move(pos[2][0]),      move(pos[2][1]) ]
    result << [ attack,               attack ]
    result << [ move(pos[3][0]),      move(pos[3][1]) ]
    result << [ blocked_attack ]
    result << [ attack,               hurt(hurts[1]) ]

    result.map!{ |r| r[0], r[1] = r[1], r[0] } unless left_lead
    result
  end

  def fight_movement_steps(steps)
    left_pos = 0
    right_pos = 100

    # TODO add randomity

    [[20,30],
     [30,20],
     [-20,-10],
     [25,5]]
  end

  def move(distance)
    [MOVEMENT[$rand.rand(2)], distance]
  end

  def attack
    [ATTACK[$rand.rand(2)], nil]
  end

  def hurt(value)
    ['hurt', value]
  end

  def blocked_attack
    [ ['punch', nil], ['low_punch', nil] ]
  end

  def win
  end

  def die
  end

  def sample_round_dominate_steps
    [['walk', 30],
     ['jump', 20],
     ['walk', -10],
     ['jump', 10],
     ['low_punch', nil],
     ['punch', nil],
     ['walk', -50]]
  end

  def sample_round_obey_steps
    [['jump', 20],
     ['walk', 20],
     ['walk', 10],
     ['jump', 0],
     ['punch', nil],
     ['hurt', 48],
     ['walk', -50]]
  end

  def sample_fatality_win_steps
    [['walk', 30],
     ['punch', nil],
     ['walk', -10],
     ['jump', 10],
     ['walk', 20],
     ['hurt', nil],
     ['low_punch', nil],
     ['walk', -10],
     ['fatality', nil],
     ['jump', -20],
     ['win', nil]]
  end

  def sample_fatality_loose_steps
    [['walk', 50],
     ['jump', 10],
     ['walk', -10],
     ['low_punch', nil],
     ['punch', nil],
     ['punch', nil],
     ['hurt', nil],
     ['walk', 5],
     ['hurt', nil],
     ['die', nil],
     ['blank', nil]]
  end

  def sample_round(left_lead = false)
    if left_lead
      sample_round_dominate_steps.zip(sample_round_obey_steps)
    else
      sample_round_obey_steps.zip(sample_round_dominate_steps)
    end
  end

  def sample_fatality(left_lead = false)
    if left_lead
      sample_fatality_win_steps.zip(sample_fatality_loose_steps)
    else
      sample_fatality_loose_steps.zip(sample_fatality_win_steps)
    end
  end

  def damage(healths, left_lead, steps = 2)
    res = []
    looser = left_lead ? healths[:quiz] : healths[:player]

    value = looser[:start]
    (steps-1).times do
      res << $rand.rand((looser[:final]+1)..(value-1))
      value -= res[-1]
    end

    res << looser[:final]
  end
end
