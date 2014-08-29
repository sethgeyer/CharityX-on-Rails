class WagerMailer < ActionMailer::Base
  default from: 'seth.geyer@gmail.com'

  def send_non_registered_user_wager(non_registered_wager)
    @non_registered_user = non_registered_wager.non_registered_user
    @unique_identifier = non_registered_wager.unique_id
    @wager_id = non_registered_wager.proposed_wager.id
    mail(to: @non_registered_user, subject: "Wanna bet?")
  end


end