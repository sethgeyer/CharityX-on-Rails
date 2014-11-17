class UserMailer < ActionMailer::Base
  default from: 'notifications@charity-x.com-no-reply'

  def welcome_email(user)
    @user = user
    @url = 'http://charity-x.herokuapp.com/'
    mail(to: @user.email, subject: "Welcome to Charity-X")
  end


  def password_reset_email(requester)
    @requester = requester
    @unique_identifier = requester.unique_identifier
    mail(to: @requester.email, subject: "Welcome to Charity-X")
  end


  def send_tax_receipt_email(deposit)
    @deposit = deposit
    mail(to: @deposit.user.email, subject: "Charitable Gift Receipt")
  end


end

