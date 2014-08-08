
class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: {message: "Username is not unique.  Please select another."}

  #<<<< turned these validations off during development
  validates :email, presence: true
  validates :ssn, presence: true
  validates :ssn, uniqueness: {message:  "A user with this social security number already exists."}
  validates :ssn, length: {minimum: 9, maximum: 9, message: "not a valid SSN."}
  validates :password, length: {minimum: 7, message: "Password must be at least 7 characters"}
  has_one :account

end