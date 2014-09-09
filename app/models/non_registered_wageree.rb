class NonRegisteredWageree < ActiveRecord::Base

  belongs_to :wager


  def self.create_a_new_one(wager_id, wageree_email_provided_by_wagerer)
    non_registred_wageree = NonRegisteredWageree.new
    non_registred_wageree.wager_id = wager_id
    non_registred_wageree.email = wageree_email_provided_by_wagerer
    non_registred_wageree.save!
    return non_registred_wageree
  end

end