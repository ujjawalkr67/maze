# Ensure Role exists
admin_role = Role.find_or_create_by(name: "admin")

# Create a default admin
admin = User.find_or_initialize_by(email: "ujjawalkr67@gmail.com") do |user|
  user.first_name = "Ujjawal"
  user.last_name = "Kumar"
  user.phone_number = "9876543210"
  user.password = "password"
  user.password_confirmation = "password"
end

if admin.new_record? || admin.changed?
  admin.save!
  admin.add_role(:admin) # Assign the admin role
  puts "✅ Admin User Created: #{admin.email}"
else
  puts "ℹ️ Admin User Already Exists: #{admin.email}"
end
