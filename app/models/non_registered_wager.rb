class NonRegisteredWager < ActiveRecord::Base
  validates :unique_id,  :uniqueness => true
  belongs_to :proposed_wager
end