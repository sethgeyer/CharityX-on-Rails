class Dashboard


  def chip_count(kenny_loggins, status)
    kenny_loggins.chips.where(status: status).count
  end


  def sum_of_deposits(kenny_loggins)
    kenny_loggins.deposits.sum(:amount) / 100
  end

  def sum_of_distributions(kenny_loggins)
    kenny_loggins.distributions.sum(:amount) / 100
  end

  def sum_of_winnings(kenny_loggins)
    (Wager.where(winner_id: kenny_loggins.id).sum(:amount) / 100) - ((kenny_loggins.wagers.where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id).where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100))
  end

  def sum_of_wagered(kenny_loggins)
    (kenny_loggins.wagers.where(winner_id: nil).where('status != ?', 'declined').where('status != ?', 'expired').sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id, status: "accepted").where(winner_id: nil).sum(:amount) / 100)
  end

  def sum_of_net_amount(kenny_loggins)
    self.sum_of_deposits(kenny_loggins) - self.sum_of_distributions(kenny_loggins) - self.sum_of_wagered(kenny_loggins) + self.sum_of_winnings(kenny_loggins)
  end

  def registered_wagers(kenny_loggins)
    unfiltered_user_wagers = (kenny_loggins.wagers + Wager.where(wageree_id: kenny_loggins.id))
    Wager.compile_wagers_to_view_based_on_user_preferences(kenny_loggins, unfiltered_user_wagers)
  end

  def public_wagers(kenny_loggins)
    unfiltered_public_wagers = Wager.where(wageree_id: nil).where('user_id != ?', kenny_loggins.id).select { |wager| wager.non_registered_wageree == nil }
    Wager.compile_wagers_to_view_based_on_user_preferences(kenny_loggins, unfiltered_public_wagers)
  end
end