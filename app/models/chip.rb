class Chip < ActiveRecord::Base
  CHIP_VALUE = 10

  belongs_to :charity

  def self.convert_currency_to_chips(user_id, deposit_amount, deposit_create_date, availability = nil)

    number_of_chips = self.convert_from_pennies_to_chips(deposit_amount)

    number_of_chips.times {
      chip = Chip.new
      chip.user_id = user_id
      chip.owner_id = user_id
      chip.status = availability
      chip.charity_id = nil
      chip.created_at = deposit_create_date
      chip.cashed_in_date = nil
      chip.save!
    }
    end

  def self.mark_as_distributed_to_charity(user_id, distribution_amount, distribution_date, charity_id)
    number_of_chips = self.convert_from_pennies_to_chips(distribution_amount)
    chips = self.find_the_available(user_id).order('created_at ASC').first(number_of_chips)
    chips.each do |chip|
      chip.status = "distributed"
      chip.charity_id = charity_id
      chip.cashed_in_date = distribution_date
      chip.save!
    end
  end

  def self.set_status_to_wagered(wagerer_id, wagered_amount )
    number_of_chips = self.convert_from_pennies_to_chips(wagered_amount)

    chips = self.find_the_available(wagerer_id).first(number_of_chips)
    chips.each do |chip|
      chip.status = "wagered"
      chip.save!
    end
  end


  def self.find_the_available(user_id)
    Chip.where(user_id: user_id).where(status: "available")
  end

  def self.convert_from_pennies_to_chips(amount)
    amount / 100 / Chip::CHIP_VALUE
  end

#NEW UNTESTED METHODS
  def self.set_status_to_available(user_id, wagered_amount )
    number_of_chips = self.convert_from_pennies_to_chips(wagered_amount)

    chips = self.find_the_wagered(user_id).first(number_of_chips)
    chips.each do |chip|
      chip.status = "available"
      chip.save!
    end
  end

  def self.find_the_wagered(user_id)
    Chip.where(user_id: user_id).where(status: "wagered")
  end


  def self.reassign_to_winner(loser_user_id, winner_user_id, wagered_amount)
    number_of_chips = self.convert_from_pennies_to_chips(wagered_amount)
    chips = self.find_the_wagered(loser_user_id).first(number_of_chips)
    chips.each do |chip|
      chip.status = "available"
      chip.user_id = winner_user_id
      chip.save!
    end
  end

  def self.sweep_the_pot(kenny_loggins, wager)
    if kenny_loggins.id == wager.user_id
      winners_chips = Chip.set_status_to_available(wager.wageree_id, wager.amount)
      losers_chips = Chip.reassign_to_winner(kenny_loggins.id, wager.wageree_id, wager.amount )
    else
      winners_chips = Chip.set_status_to_available(wager.user_id, wager.amount)
      losers_chips = Chip.reassign_to_winner(kenny_loggins.id, wager.user_id, wager.amount )
    end
  end
end
