class NonRegisteredWager < ActiveRecord::Base
  validates :unique_id,  :uniqueness => true
  belongs_to :wager
end