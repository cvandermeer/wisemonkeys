class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:vote, :show, :edit, :update, :destroy]
  before_action :change, :only => [:edit, :update, :destroy]
  before_action :signedin, :only => [:edit, :update, :destroy, :create, :new]
  before_action :b_accountcheck, :only => [:edit, :update, :destroy, :create, :new]
  before_action :activated, :only => [:edit, :update, :destroy, :create, :new]

  # GET /competitions
  # GET /competitions.json
  def index
    @competitions = Competition.all
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
  end

   # GET /competitions/1
  # GET /competitions/1.json

  def votepage
    @competition = Competition.find(params[:id])
  end


  def homepage
    @competitions = Competition.all
  end


  # GET /competitions/new
  def new
    @competition = Competition.new
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions
  # POST /competitions.json
  def create
    @competition = Competition.new(competition_params)
    @competition.user = current_user
    if @competition.save
      redirect_to @competition, notice: 'Competition was successfully created.'
    else
      render 'new'
    end
  end

  # PATCH/PUT /competitions/1
  # PATCH/PUT /competitions/1.json
  def update
    if @competition.update(competition_params)
      redirect_to @competition, notice: 'Competition was successfully updated.'
    else
      render 'edit'
    end
  end

  # DELETE /competitions/1
  # DELETE /competitions/1.json
  def destroy
    @competition.destroy
    redirect_to competitions_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competition_params
      params.require(:competition).permit(:title, :description, :prize, :prize_2, :prize_3, :deadline, :deadline_signin)
    end

    def change
      unless current_user == @competition.user || current_user.administrator?
        redirect_to @competition, notice: 'U bent niet gemachtigd'
      end
    end

    def signedin
      unless signed_in?
        redirect_to :back, notice: 'U bent niet gemachtigd'
      end
    end

    def b_accountcheck
      unless current_user.b_account? || current_user.administrator?
        redirect_to competitions_path, notice: 'U bent niet gemachtigd'
      end
    end

    def activated
      unless current_user.activated?
        redirect_to :back, notice: 'Uw account is nog niet geactiveerd!'
      end
    end
end

