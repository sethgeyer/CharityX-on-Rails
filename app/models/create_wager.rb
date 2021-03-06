class CreateWager
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :amount, :title, :details, :wageree_lookup,
                :date_of_wager, :time_of_wager, :selected_winner_id,
                :game_uuid, :kenny_loggins

  validate :wager_if_valid

  def self.model_name
    ActiveModel::Name.new(Wager)
  end

  def initialize(attrs, previous_wager_id = nil)
    super(attrs)

    @wager = Wager.new
             
    if previous_wager_id
      @wager.duplicate_of(previous_wager_id, kenny_loggins)
      set_attributes_from_wager!
    end
  end

  def save
    @wager = if sport_game.present?
               kenny_loggins.wagers.new.build_a_sports_game_wager(sport_game, wageree, wager_amount_in_dollars, selected_winner_id)
             else
               kenny_loggins.wagers.new(amount: amount, title: title, details: details).build_a_custom_wager(date_of_wager, time_of_wager, wageree, wager_amount_in_dollars)
             end

    if kenny_loggins.insufficient_funds_for(wager_amount_in_dollars, "available")
      wager.amount = kenny_loggins.maximum_dollars_available
      errors.add(:amount, "You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $#{kenny_loggins.maximum_dollars_available}")

      @remaining_games = SportsGame.where('date > ?', DateTime.now.utc)
      return false
    end

    unless valid?
      wager.amount = wager_amount_in_dollars

      utc_time = wager.date_of_wager
      if utc_time
        wager.date_of_wager = "#{utc_time.in_time_zone(kenny_loggins.timezone).strftime("%a %e-%b-%y")}"
        @time_of_wager = "#{utc_time.in_time_zone(kenny_loggins.timezone).strftime("%l:%M %p")} (loc)"
      end

      return false
    end

    ActiveRecord::Base.transaction do
      wager.save!
      Chip.set_status_to_wagered(wager.user.id, wager.amount)
      send_the_appropriate_notification_email(wageree, wager)
    end
  end

  def notice
    @notice
  end

  private

  attr_reader :wager

  def set_attributes_from_wager!
    [:amount, :title, :details].each do |attr|
      self.send("#{attr}=", wager.send(attr))
    end

    self.wageree_lookup = User.find(wager.wageree_id).username
  end

  def wager_if_valid
    unless wager.valid?
      collect_errors(wager)
    end
  end

  def send_the_appropriate_notification_email(wageree, wager)
    if wageree.is_a?(User)
      WagerMailer.send_registered_user_wager(wager).deliver
      set_notice("Your proposed wager has been sent to #{wageree.username}.")
    elsif wageree.is_a?(NonRegisteredWageree)
      non_registered_wageree = NonRegisteredWageree.create!(wager_id: wager.id, email: wageree.email)
      WagerMailer.send_non_registered_user_wager(non_registered_wageree).deliver
      set_notice("A solicitation email has been sent to #{non_registered_wageree.email}")
    else
      set_notice("No username was provided.  Your wager is listed in the public wagers section")
    end
  end

  def set_notice(notice)
    @notice = notice
  end

  def sport_game
    @_sport_game ||= SportsGame.find_by(uuid: game_uuid)
  end

  def wager_amount_in_dollars
    @_wager_amount_in_dollars ||= amount_stripped_of_dollar_sign_and_commas(amount)
  end

  def wageree
    @_wageree ||= Wager.find_the_proposed_wageree(wageree_lookup)
  end

  def amount_stripped_of_dollar_sign_and_commas(user_input_amount)
    user_input_amount.gsub("$", "").gsub(",", "").to_i
  end

  def collect_errors(object)
    object.errors.each do |error, value| 
      self.errors.add(error, value)
    end
  end
end
