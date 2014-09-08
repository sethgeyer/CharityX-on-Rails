
class Distribution < ActiveRecord::Base

  belongs_to :charity
  belongs_to :user

  validate :amount_of_distribution_is_within_thresholds, on: :create

  def amount_of_distribution_is_within_thresholds
    dollar_amount = amount / 100
    unless dollar_amount % $ChipValue == 0 && dollar_amount >= $ChipValue
      errors.add(:amount, "All distributions must be in increments of $#{$ChipValue}.")
    end
  end



end