class UserMailer < ActionMailer::Base
  default from: 'charity-x admin -no reply'

  def welcome_email(user)
    @user = user
    @url = 'http://charity-x.herokuapp.com/'
    mail(to: @user.email, subject: "Welcome to Charity-X")
  end

end

