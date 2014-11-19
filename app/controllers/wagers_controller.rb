class WagersController < ApplicationController
  #TODO: get rid of me, we need this for the timezone_adjusted_clock
  include ApplicationHelper

  def new
    if kenny_loggins.insufficient_funds_for(Chip::CHIP_VALUE, "available")
      flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can wager."
      redirect_to user_dashboard_path and return
    end

    @wager = CreateWager.new({kenny_loggins: kenny_loggins}, params[:pwid])
    @wager.time_of_wager = timezone_adjusted_clock(DateTime.now.beginning_of_hour + 3.hours) 
    @remaining_games = SportsGame.remaining_games

    render :new
  end

  def create
    @wager = CreateWager.new(
      {
        kenny_loggins: kenny_loggins,
      }.merge(allowed_params)
    )

    if @wager.save
      flash[:notice] = @wager.notice
      redirect_to user_dashboard_path
    else
      @remaining_games = SportsGame.remaining_games
      render :new
    end
  end

  def update
    UpdateWager.new(
      params.merge(flash: flash, kenny_loggins: kenny_loggins)
    ).save!

    redirect_to user_dashboard_path(anchor: "wager-bucket-#{params[:id]}")
  end

  def win
    wager = Wager.find_by(id: params[:id], status: "accepted")
    wager.assign_the_win(kenny_loggins)
    wager.save!

    redirect_to user_dashboard_path(anchor: "wager-bucket-#{params[:id]}")
  end

  def loss
    wager = Wager.find_by(id: params[:id], status: "accepted")

    ActiveRecord::Base.transaction do
      wager.assign_the_loss(kenny_loggins)
      wager.save!
      Chip.sweep_the_pot(kenny_loggins, wager)
    end

    redirect_to user_dashboard_path(anchor: "wager-bucket-#{params[:id]}")
  end

  def accept
    AcceptWager.new(wager_id: params[:id], flash: flash, kenny_loggins: kenny_loggins).save!
    redirect_to user_dashboard_path(anchor: "wager-bucket-#{params[:id]}")
  end
  
  def destroy
    wager = Wager.find_by(id: params[:id], status: "w/wageree")

    #<<<<< The below line and the if == nil code were added to address the situations where a wageree has accepted a bet or it expired
    #before the wagerer who wants to withdraw the bet refreshes his view.  This ensures that if the bet is "accepted, a wagerer that tries to witdraw it, gets a message stating
    #that it can't be withdrawn.
    if wager.nil?
      flash[:notice] = "Wager has already been accepted or expired before you could withdraw it."
    else
      ActiveRecord::Base.transaction do
        wager.destroy
        Chip.set_status_to_available(kenny_loggins.id, wager.amount)
      end

      flash[:notice] = "Your wager has been withdrawn"
    end

    redirect_to user_dashboard_path
  end

  private

  def allowed_params
    params.require(:wager).permit(
      :title, :details, :amount, :wageree_lookup,
      :selected_winner_id, :game_uuid,
      :date_of_wager, :time_of_wager
    )
  end

  def outcome_update_symbol(wager_id)
    "update-#{wager_id}".to_sym
  end
end
