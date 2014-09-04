
class Wager < ActiveRecord::Base
  belongs_to :account
  has_one :non_registered_user, dependent: :destroy
  has_many :wager_view_preferences

  validates :title, presence: true
  validate :date_of_wager_must_be_in_the_future, on: :create


  def date_of_wager_must_be_in_the_future
    if date_of_wager == nil  || date_of_wager < Date.today
      errors.add(:date_of_wager, "can't be blank or in the past")
    end
  end

end