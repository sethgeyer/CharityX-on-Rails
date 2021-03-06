
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

  def assign_the_win(winner)
    if winner == user
      self.wagerer_outcome = "I Won"
    else
      self.wageree_outcome = "I Won"
    end
  end

  def assign_the_loss(loser)
    self.winner_id = if loser == user
                       wageree_id
                     else
                       user_id
                     end

    self.wageree_outcome = "I Lost"
    self.status = "completed"
  end


  def build_a_sports_game_wager(sport_game, wageree, wager_amount_in_dollars, selected_winner)
    self.wageree_id = wageree.id if wageree.is_a?(User)
    self.status = "w/wageree"
    self.amount = amount_converted_to_pennies(wager_amount_in_dollars)
    self.game_uuid = sport_game.uuid
    self.selected_winner_id = selected_winner if [sport_game.vs_id, sport_game.home_id].include?(selected_winner)
    self.date_of_wager = sport_game.date
    self.home_id = sport_game.home_id
    self.vs_id = sport_game.vs_id
    self.game_week = sport_game.week
    self.wager_type = "SportsWager"
    self.title = self.return_the_wager_title(sport_game.home_id, sport_game.full_home_name, sport_game.vs_id, sport_game.full_visitor_name, selected_winner_id)
    self.details = self.return_wager_details(sport_game)
    return self
  end

  def build_a_custom_wager(date, time, wageree, wager_amount_in_dollars)

    if date != ""
      strung_out_date_time = "#{date} #{time}".in_time_zone(self.user.timezone)
      self.date_of_wager = strung_out_date_time.utc if strung_out_date_time
    else

      self.date_of_wager = nil
    end
    self.wageree_id = wageree.id if wageree.is_a?(User)
    self.status = "w/wageree"
    self.amount = amount_converted_to_pennies(wager_amount_in_dollars)
    self.wager_type = "CustomWager"
    return self
  end


  def return_wager_details(game)
    string = "@#{game.venue}"
    string += " / Forecast: #{game.temperature} and #{game.condition}" if game.temperature && game.condition
    string
  end


  def amount_converted_to_pennies(dollar_amount)
    dollar_amount * 100
  end

  def duplicate_of(original_wager_id, kenny_loggins)
    rematch_wager = Wager.find(original_wager_id)

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

  def cancel!
    self.status = "declined"

    transaction do
      self.save!
      Chip.set_status_to_available(user_id, amount)
    end
  end

  def self.find_the_proposed_wageree(wageree_username_or_email)
    found_user = User.find_by(username: wageree_username_or_email.downcase) || User.find_by(email: wageree_username_or_email.downcase)
    if found_user
      found_user
    elsif wageree_username_or_email.include?("@")
      NonRegisteredWageree.new(email: wageree_username_or_email)
    else
      nil
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

  def identify_current_user_outcome(kenny_loggins)
    if kenny_loggins.id == self.winner_id
      "I Won! |"
    else
      "I Lost! |"
    end
  end

  def return_the_wager_title(home_id, full_home_name, vs_id, full_visitor_name, selected_winner_id)
    if selected_winner_id == home_id
      selected_loser = full_visitor_name
      selected_winner = full_home_name
    else
      selected_winner = full_visitor_name
      selected_loser = full_home_name
    end

    "The #{selected_winner} beat the #{selected_loser}"
  end

  private

  def date_of_wager_must_be_in_the_future
    if date_of_wager == nil  || date_of_wager < DateTime.now.utc
      errors.add(:date_of_wager, "can't be blank or in the past")
    end
  end

  def amount_of_wager_is_within_thresholds

    dollar_amount = amount / 100
    unless dollar_amount % 10 == 0 && dollar_amount >= 10
      errors.add(:amount, "All wagers must be in increments of $10.")
    end
  end
end 
