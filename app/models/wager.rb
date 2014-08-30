
class Wager < ActiveRecord::Base
  belongs_to :account
  has_one :non_registered_user, dependent: :destroy

  validates :title, presence: true
  validates :date_of_wager, presence: true

end