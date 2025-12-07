# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create initial admin user
admin = Admin.find_or_create_by!(email: 'teste@teste.com') do |a|
  a.password = 'qwe123'
  a.password_confirmation = 'qwe123'
  puts "Created admin user: #{a.email}"
end

# Create OAuth Application for api testing
app = Doorkeeper::Application.find_or_create_by!(name: 'API application for testing') do |application|
  application.redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
  application.scopes = ''
  puts "Created OAuth Application: #{application.name}"
end

puts "\n#####################################################"
puts "\nTo get an access token, use:"
puts "  curl -X POST http://localhost:3000/oauth/token \\"
puts "    -d 'grant_type=password' \\"
puts "    -d 'email=teste@teste.com' \\"
puts "    -d 'password=qwe123' \\"
puts "    -d 'client_id=#{app.uid}' \\"
puts "    -d 'client_secret=#{app.secret}'"
puts "#######################################################"

puts "\nSeeds completed successfully!"
