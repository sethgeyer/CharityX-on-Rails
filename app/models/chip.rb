
class Chip < ActiveRecord::Base
  def convert_currency_to_chips(user_id, deposit_amount, deposit_create_date, availability = nil)

    number_of_chips = convert_from_pennies_to_chips(deposit_amount)

    number_of_chips.times {
      chip = Chip.new
      chip.user_id = user_id
      chip.owner_id = user_id
      chip.status = availability
      chip.l1_tag_id = nil
      chip.l2_tag_id = nil
      chip.charity_id = nil
      chip.purchase_date = deposit_create_date
      chip.cashed_in_date = nil
      chip.save!
    }
    end

  def cash_out(user_id, distribution_amount, distribution_date, charity_id)
    number_of_chips = convert_from_pennies_to_chips(distribution_amount)
    chips = find_the_available(user_id).first(number_of_chips)
    chips.each do |chip|
      chip.status = "distributed"
      chip.charity_id = charity_id
      chip.cashed_in_date = distribution_date
      chip.save!
    end
  end

  def change_status_to_wagered(wagerer_id, wagered_amount )
    number_of_chips = convert_from_pennies_to_chips(wagered_amount)

    chips = find_the_available(wagerer_id).first(number_of_chips)
    chips.each do |chip|
      chip.status = "wagered"
      chip.save!
    end
  end

#NEW UNTESTED METHODS
  def change_status_to_available(user_id, wagered_amount )
    number_of_chips = convert_from_pennies_to_chips(wagered_amount)

    chips = find_the_wagered(user_id).first(number_of_chips)
    chips.each do |chip|
      chip.status = "available"
      chip.save!
    end
  end

  def find_the_wagered(user_id)
    Chip.where(user_id: user_id).where(status: "wagered")
  end


  def reassign_to_winner(loser_user_id, winner_user_id, wagered_amount)
    number_of_chips = convert_from_pennies_to_chips(wagered_amount)
    chips = find_the_wagered(loser_user_id).first(number_of_chips)
    chips.each do |chip|
      chip.status = "available"
      chip.user_id = winner_user_id
      chip.save!
    end
  end

  def find_the_available(user_id)
    Chip.where(user_id: user_id).where(status: "available")
  end

  def convert_from_pennies_to_chips(amount)

    amount / 100 / $ChipValue
  end


end