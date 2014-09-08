class WagerViewPreference < ActiveRecord::Base

  belongs_to :user
  belongs_to :wager

end