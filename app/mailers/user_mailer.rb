class UserMailer < ApplicationMailer
    default from: 'ujjawalkr67@gmail.com'
  
    def welcome_email(user)
      @user = user
      mail(to: @user.email, subject: 'Welcome to Our Platform!')
    end
  end
  
