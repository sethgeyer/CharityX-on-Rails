class UserMailer < ActionMailer::Base
  default from: 'seth.geyer@gmail.com'

  def welcome_email(user)
    @user = user
    @url = 'http://google.com'
    mail(to: @user.email, subject: "Welcome to Charity-X")
  end

end

