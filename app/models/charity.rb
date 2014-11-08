
class Charity < ActiveRecord::Base

  validates :name, :tax_id, :poc, :poc_email, presence: true

end