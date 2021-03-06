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


  def summary_of_distributed_losses(kenny_loggins)
    distributed_lost_chips = Chip.where(owner_id: kenny_loggins.id).where('user_id != ?', kenny_loggins.id).where('status = ?', 'distributed')

    hash = {}
    x = distributed_lost_chips.each do |chip|
      if hash[chip.charity.name]
        hash[chip.charity.name] += 1
      else
        hash[chip.charity.name] = 1
      end
    end
    hash
  end


  def sum_of_winnings(kenny_loggins)
    sum_of_gains(kenny_loggins) - sum_of_losses(kenny_loggins)
  end

  def sum_of_gains(kenny_loggins)
    list_of_gains(kenny_loggins).sum(:amount) / 100
  end

  def list_of_gains(kenny_loggins)
    Wager.where(winner_id: kenny_loggins.id)
  end

  def sum_of_losses(kenny_loggins)
    (kenny_loggins.wagers.where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id).where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100)
  end

  # def list_of_losses(kenny_loggins)
  #   kenny_loggins.wagers.where('winner_id != ?', kenny_loggins.id) + Wager.where(wageree_id: kenny_loggins.id).where('winner_id != ?', kenny_loggins.id)
  #
  # end

  def sum_of_losses_in_others_accounts(kenny_loggins)
    Chip.where(owner_id: kenny_loggins.id).where('user_id != ?', kenny_loggins.id).where('status != ?', 'distributed').count * 10
  end

  def sum_of_distributed_losses(kenny_loggins)
    Chip.where(owner_id: kenny_loggins.id).where('user_id != ?', kenny_loggins.id).where('status = ?', 'distributed').count * 10
  end

  def sum_of_wagered(kenny_loggins)
    (kenny_loggins.wagers.where(winner_id: nil).where('status != ?', 'declined').where('status != ?', 'expired').sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id, status: "accepted").where(winner_id: nil).sum(:amount) / 100)
  end

  def sum_of_net_amount(kenny_loggins)
    self.sum_of_deposits(kenny_loggins) - self.sum_of_distributions(kenny_loggins) - self.sum_of_wagered(kenny_loggins) + self.sum_of_winnings(kenny_loggins)
  end

  def registered_wagers(kenny_loggins)
    unfiltered_user_wagers = (kenny_loggins.wagers + Wager.where(wageree_id: kenny_loggins.id))
    Wager.compile_wagers_to_view_based_on_user_preferences(kenny_loggins, unfiltered_user_wagers).sort_by { |wager| wager.date_of_wager}
  end

  def public_wagers(kenny_loggins)
    unfiltered_public_wagers = Wager.where(wageree_id: nil).where('user_id != ?', kenny_loggins.id).where('date_of_wager > ?', DateTime.now).select { |wager| wager.non_registered_wageree == nil }
    Wager.compile_wagers_to_view_based_on_user_preferences(kenny_loggins, unfiltered_public_wagers).sort_by { |wager| wager.date_of_wager}
  end

end