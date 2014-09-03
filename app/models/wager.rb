
class Wager < ActiveRecord::Base
  belongs_to :account
  has_one :non_registered_user, dependent: :destroy
  has_many :wager_view_preferences

  validates :title, presence: true
  validates :date_of_wager, presence: true

end