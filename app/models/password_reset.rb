class PasswordReset < ActiveRecord::Base
  validates :email, presence: true
end