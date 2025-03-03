class AdminMailer < ApplicationMailer
    default from: 'ujjawalkr67@gmail.com'
  
    def upload_summary(admin_email, created_users, failed_users)
      @created_users = created_users
      @failed_users = failed_users
      mail(to: admin_email, subject: "User Upload Summary")
    end
  end
  