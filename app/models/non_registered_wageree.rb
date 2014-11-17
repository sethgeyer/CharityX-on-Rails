class NonRegisteredWageree < ActiveRecord::Base

  belongs_to :wager

  before_save :downcase_email

  private

  def downcase_email
    self.email.downcase!
  end


end