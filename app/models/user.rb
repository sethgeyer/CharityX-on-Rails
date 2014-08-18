
class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, uniqueness: {message: "Username is not unique.  Please select another."}

  #<<<< turned these validations off during development
  validates :email, presence: true
  validates :password, length: {minimum: 7, message: "Password must be at least 7 characters", :allow_blank => true}
  has_one :account

end