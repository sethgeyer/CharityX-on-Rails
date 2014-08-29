class WagerMailer < ActionMailer::Base

  # def set_default_from(sender)
  #   @sender = sender
  #
  # end

  default from: "wager-invitation@charity-x.com-no-reply"

  def send_non_registered_user_wager(non_registered_wager)
    @wager = ProposedWager.find(non_registered_wager.proposed_wager.id)
    @non_registered_user = non_registered_wager.non_registered_user
    @url = 'http://charity-x.herokuapp.com/'
    mail(to: @non_registered_user, subject: "Wanna bet for a good cause?")
  end


end