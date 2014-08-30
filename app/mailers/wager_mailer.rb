class WagerMailer < ActionMailer::Base

  # def set_default_from(sender)
  #   @sender = sender
  #
  # end

  default from: "wager-invitation@charity-x.com-no-reply"

  def send_non_registered_user_wager(non_registered_user)
    @wager = Wager.find(non_registered_user.wager.id)
    @non_registered_user = non_registered_user.email
    @url = 'http://charity-x.herokuapp.com/'
    mail(to: @non_registered_user, subject: "Wanna bet for a good cause?")
  end

  def send_registered_user_wager(wager)
    @wager = wager
    @wageree = User.find(wager.wageree_id)
    @url = 'http://charity-x.herokuapp.com/'
    mail(to: @wageree.email, subject: "#{@wager.account.user.username} wants to bet...")
  end


end