
class Deposit < ActiveRecord::Base
  belongs_to :user

  validate :amount_of_deposit_is_within_thresholds, on: :create

  def amount_of_deposit_is_within_thresholds
    dollar_amount = amount / 100
    unless dollar_amount % $ChipValue == 0 && dollar_amount <= 1000 && dollar_amount >= $ChipValue
      errors.add(:amount, "All deposits must be in increments of $#{$ChipValue} and no more than $1,000.")
    end
  end

end