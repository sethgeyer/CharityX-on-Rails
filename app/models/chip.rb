
class Chip < ActiveRecord::Base
  def purchase(user_id, account_id, deposit_amount, deposit_create_date, availability = nil)
    number_of_chips = convert_from_pennies(deposit_amount)

    number_of_chips.times {
      chip = Chip.new
      chip.account_id = account_id
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

  def cash_out(account_id, distribution_amount, distribution_date, charity_id)
    number_of_chips = convert_from_pennies(distribution_amount)
    chips = find_the_available(account_id).first(number_of_chips)
    chips.each do |chip|
      chip.status = "distributed"
      chip.charity_id = charity_id
      chip.cashed_in_date = distribution_date
      chip.save!
    end
  end

  def change_status_to_wager(account_id, wagered_amount )
    number_of_chips = convert_from_pennies(wagered_amount)
    chips = find_the_available(account_id).first(number_of_chips)
    chips.each do |chip|
      chip.status = "wagered"
      chip.save!
    end
  end

  def find_the_available(account_id)
    Chip.where(account_id: account_id).where(status: "available")
  end

  def convert_from_pennies(amount)
    amount / 100 / 10
  end


end