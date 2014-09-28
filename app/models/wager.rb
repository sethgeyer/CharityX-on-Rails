
class Wager < ActiveRecord::Base
  belongs_to :user
  has_one :non_registered_wageree, dependent: :destroy
  has_many :wager_view_preferences, dependent: :destroy

  validates :title, presence: true
  validate :date_of_wager_must_be_in_the_future, on: :create
  validate :amount_of_wager_is_within_thresholds

  def self.compile_wagers_to_view_based_on_user_preferences(kenny_loggins, wagers)
    @wagers = wagers.collect do |wager|
      if !WagerViewPreference.where(user_id: kenny_loggins.id, wager_id: wager.id, show: false).first
        wager
      end
    end
    @wagers.select { |wager| wager != nil }
  end


  def assign_the_win(kenny_loggins, wager)
    if kenny_loggins.id == wager.user_id
      wager.wagerer_outcome = "I Won"
    else
      wager.wageree_outcome = "I Won"
    end
  end

  def assign_the_loss(kenny_loggins, wager)
    if kenny_loggins.id == wager.user_id
      wager.wagerer_outcome = "I Lost"
      wager.winner_id = wager.wageree_id
    else
      wager.wageree_outcome = "I Lost"
      wager.winner_id = wager.user_id
    end
    wager.status = "completed"
  end


  def create_as_a_duplicate_of_an_original_wager?(original_wager_id_provided, kenny_loggins)
    if original_wager_id_provided
      rematch_wager = Wager.find(original_wager_id_provided)
      if rematch_wager.user == kenny_loggins || rematch_wager.wageree_id == kenny_loggins.id
        self.title = rematch_wager.title
        self.details = rematch_wager.details
        self.wageree_id = if rematch_wager.user == kenny_loggins
                            rematch_wager.wageree_id
                          else
                            rematch_wager.user_id
                          end
        self.amount = rematch_wager.amount / 100
      end
    end
  end


  def identify_the_wageree
    if self.wageree_id
      User.find_by(id: self.wageree_id).username
    elsif self.non_registered_wageree
      self.non_registered_wageree.email
    else
      "the Public"
    end
  end

  def show_wager_details_if_present
      "Details: #{self.details}" if self.details
  end




  private

  def date_of_wager_must_be_in_the_future
    if date_of_wager == nil  || date_of_wager < Date.today
      errors.add(:date_of_wager, "can't be blank or in the past")
    end
  end

  def amount_of_wager_is_within_thresholds
    dollar_amount = amount / 100
    unless dollar_amount % $ChipValue == 0 && dollar_amount >= $ChipValue
      errors.add(:amount, "All wagers must be in increments of $#{$ChipValue}.")
    end
  end



end