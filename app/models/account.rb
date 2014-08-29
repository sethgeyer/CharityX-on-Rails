
class Account < ActiveRecord::Base
  belongs_to :user
  has_many :deposits
  has_many :distributions
  has_many :wagers
  has_many :chips
end