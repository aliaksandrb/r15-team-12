module StepGenerator
  # Assume player is always on left

  def generate(game, question, answer)
    steps = [ player: [], quiz: [] ]

    if timeouted?(game, answer)
      game_status = Question::TIMEOUT
    else
      question_status = correct?(answer, question) ? Question::PLAYER_WIN : Question::QUIZ_WIN
      healths = update_healths(game, question_status)
      game_status = finished?(healths) ? Game::FINISHED : Game::ROUND

      case game_status
      when Game::FINISHED
        case question_status
        when Question::PLAYER_WIN
          steps[:player], steps[:quiz] = fatality_win_steps, fatality_loose_steps
        when Question::QUIZ_WIN
          steps[:quiz], steps[:player] = fatality_win_steps, fatality_loose_steps
        end
      when Game::ROUND
        case question_status
        when Question::PLAYER_WIN
          steps[:player], steps[:quiz] = round_dominate_steps, round_obey_steps
        when Question::QUIZ_WIN
          steps[:quiz], steps[:player] = round_dominate_steps, round_obey_steps
        end
      end
    end

    # Format
    # { game_status: Status::Game::ROUND,
    #  question_status: Status::Question::QUIZ_WIN,
    #  player_health: 50,
    #  quiz_health: 75,
    #  steps: [['punch', 'block'],
    #          ['hurt',  'kick']] }
     { game_status: game_status,
       question_status: question_status,
       player_health: health[:player],
       quiz_health: health[:quiz],
       steps: steps
     }
  end

  def timeouted?(game, answer)
    answer.time - game.game_time > question.time_limit * 1.1
  end

  def correct?(answer, question)
    # TODO check to_s
    p question.options
    question.options[(question.answer-1).to_s] == answer.value
  end

  def update_healths(game, question_status)
    healths = { player: game.player_health, quiz: game.quiz_health }

    if question_status == Question::PLAYER_WIN
      healths[:quiz] -= Game::MAX_HEALTH / (game.quiz.question.size - game.quiz.fail_limit) + 1
    else
      healths[:player] -= Game::MAX_HEALTH / (game.quiz.fail_limit + 1) + 1
    end
    healths
  end

  def finished?(healths)
    healths[:player] <= 0 || healths[:quiz] <= 0
  end

  # Possible actions
  # 1. win
  # 2. die
  # 3. hurt
  # 4. low_punch
  # 5. punch
  # 6. jump
  # 7. walk
  # 8. fatality
  # 9. blank

  # [[action, value]]
  # All actions with the same time
  def round_dominate_steps
    [['walk', 30],
     ['jump', 20],
     ['walk', -10],
     ['jump', 10],
     ['low_punch', nil],
     ['punch', nil],
     ['walk', -50]]
  end

  def round_obey_steps
    [['jump', 20],
     ['walk', 20],
     ['walk', 10],
     ['jump', 0],
     ['punch', nil],
     ['hurt', nil],
     ['walk', -50]]
  end

  def fatality_win_steps
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

  def fatality_loose_steps
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
end
