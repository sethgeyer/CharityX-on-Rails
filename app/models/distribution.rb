
class Distribution < ActiveRecord::Base
  belongs_to :account
  belongs_to :charity

  belongs_to :user
#
end