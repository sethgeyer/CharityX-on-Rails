
class ProposedWager < ActiveRecord::Base
  belongs_to :account
  has_one :non_registered_wager

  # validates :title, presence: true
  # validates :date_of_wager, presence: true
  # validates :amount, presence: true

end