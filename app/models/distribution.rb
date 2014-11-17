
class Distribution < ActiveRecord::Base

  belongs_to :charity
  belongs_to :user

  validate :amount_of_distribution_is_within_thresholds, on: :create
  validates :charity_id, presence: true

  def amount_of_distribution_is_within_thresholds
    dollar_amount = amount / 100
    unless dollar_amount % 10 == 0 && dollar_amount >= 10
      errors.add(:amount, "All distributions must be in increments of $10.")
    end
  end


  def show_appropriate_name
    if anonymous?
      "Anonymous"
    else
      "#{user.first_name} #{user.last_name}"
    end
  end
end