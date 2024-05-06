class UserMailer < ApplicationMailer
  def welcome_user(user_mail)
    @otp = user_mail[:otp]
    mail(to: user_mail[:email],subject:"Welcoming the new user")
  end
end
