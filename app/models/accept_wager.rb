class AcceptWager
  attr_reader :wager_id, :kenny_loggins, :flash

  def initialize(options)
    @wager_id = options.fetch(:wager_id)
    @kenny_loggins = options.fetch(:kenny_loggins)
    @flash = options.fetch(:flash)
  end

  def save!
    wager = Wager.where(id: wager_id).where(status: "w/wageree").first

    if wager == nil
      flash[:notice] = "Wager s already been accepted, withdrawn or expired."
    elsif kenny_loggins.insufficient_funds_for(wager.amount / 100, "available")
      flash[outcome_update_symbol(wager_id)] = "You don't have adequate funds to accept this wager.  Please add additional funds to your account."
    else
      wager.wageree_id = kenny_loggins.id if wager.wageree_id == nil
      wager.status = "accepted"
      WagerMailer.send_wager_acceptance_email(wager).deliver
      Chip.set_status_to_wagered(kenny_loggins.id, wager.amount) if wager.save!
      flash[outcome_update_symbol(wager_id)] = "You have accepted this wager."
    end
  end

  private
  
  def outcome_update_symbol(wager_id)
    "update-#{wager_id}".to_sym
  end
end
