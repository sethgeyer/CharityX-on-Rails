
class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: {message: "Username is not unique.  Please select another."}

  #<<<< turned these validations off during development
  # validates :email, presence: true
  # validates :ssn, presence: true, uniqueness: {message:  "A user with this social security number already exists."}, length: {minimum: 9, maximum: 9}
  # validates :password, presence: true, length: {minimum: 7}
  has_one :account

end