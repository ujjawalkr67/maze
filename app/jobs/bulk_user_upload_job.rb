class BulkUserUploadJob
  include Sidekiq::Worker

  def perform(users_data, admin_email)
    created_users = []
    failed_users = []

    users_data.each do |user_data|
      user = User.new(
        first_name: user_data["first_name"],
        last_name: user_data["last_name"],
        email: user_data["email"],
        phone_number: user_data["phone_number"],
        password: user_data["password"]
      )

      if user.save
        created_users << user
        Rails.logger.info "User created: #{user.email}"
      else
        failed_users << { email: user_data["email"], errors: user.errors.full_messages }
        Rails.logger.error "Failed to create user: #{user.email}, Errors: #{user.errors.full_messages}"
      end
    end

    AdminMailer.upload_summary(admin_email, created_users, failed_users).deliver_later
  end
end
