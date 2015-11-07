class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :start]

  def choose_hero
  end

  def start
    @question = @game.questions.where.not(
      questions: { id: [@game.answered_questions.pluck(:question_id)] }
    ).first

    if @question
      @user_answer = @game.answered_questions.build
      @user_answer.question = @question

      session[:player_hero_id] = params[:hero_id]
      session[:game_id] = @game.id
      session[:question_id] = @question.id

      respond_to do |format|
        format.html
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to the_end_quiz_game_url(@game.quiz, @game) }
        format.js { render js: "window.location = '#{the_end_quiz_game_url(@game.quiz, @game)}'" }
      end
    end
  end

  def the_end
    @message = 'Thanks!'
  end

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @quiz = Quiz.find(params[:quiz_id])
    @game = @quiz.games.build
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @quiz = Quiz.find(params[:quiz_id])
    @game = @quiz.games.build(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to start_quiz_game_url(@quiz, @game), notice: 'Game was successfully created.' }
#        format.html { redirect_to quiz_game_url(@quiz, @game), notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to quiz_games_url(@game.quiz), notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:player_email)
    end
end
