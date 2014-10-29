
class Deposit < ActiveRecord::Base
  belongs_to :user

  validate :amount_of_deposit_is_within_thresholds, on: :create

  def amount_of_deposit_is_within_thresholds
    dollar_amount = amount / 100
    unless dollar_amount % 10 == 0 && dollar_amount <= 1000 && dollar_amount >= 10
      errors.add(:amount, "All deposits must be in increments of $10 and no more than $1,000.")
    end
  end

end