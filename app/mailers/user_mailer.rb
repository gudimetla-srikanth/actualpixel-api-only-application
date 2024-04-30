class UserMailer < ApplicationMailer
  def welcome_user(user_mail)
    mail(to: user_mail,subject:"Welcoming the new user")
  end
end
