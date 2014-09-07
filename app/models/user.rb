
class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, uniqueness: {message: "is not unique.  Please select another."}
  validates :username, format: { with: /\A\w*\z/, message: "can only be letters, underscore, or numbers"}
  #<<<< turned these validations off during development
  validates :email, presence: true, uniqueness: {message: "already exists.  If you wish to reset your password, select 'Forgot Password' from the top menu"}
  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :password, length: {minimum: 7, message: "Password must be at least 7 characters", :allow_blank => true}
  has_one :account
  has_many :wager_view_preferences

  has_many :deposits
  has_many :chips
  has_many :wagers
  has_many :distributions
end