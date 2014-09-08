
class Wager < ActiveRecord::Base
  belongs_to :user
  has_one :non_registered_wageree, dependent: :destroy
  has_many :wager_view_preferences, dependent: :destroy

  validates :title, presence: true
  validate :date_of_wager_must_be_in_the_future, on: :create


  def date_of_wager_must_be_in_the_future
    if date_of_wager == nil  || date_of_wager < Date.today
      errors.add(:date_of_wager, "can't be blank or in the past")
    end
  end


  def self.compile_wagers_to_view_based_on_user_preferences(kenny_loggins, wagers)
    @wagers = wagers.collect do |wager|
      if !WagerViewPreference.where(user_id: kenny_loggins.id, wager_id: wager.id, show: false).first
        wager
      end
    end
    @wagers.select { |wager| wager != nil }
  end



end