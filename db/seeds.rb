# Ensure Role exists
Role.find_or_create_by(name: "admin")
Role.find_or_create_by(name: "user")

# Create a default admin
admin = User.find_or_create_by(email: "admin@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.add_role(:admin) # Assign the admin role
end

puts "Admin User Created: #{admin.email}"
