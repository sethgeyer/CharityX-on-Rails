
class ProposedWager < ActiveRecord::Base
  belongs_to :account
  has_one :non_registered_wager

end