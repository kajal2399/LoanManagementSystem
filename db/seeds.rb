admin = User.find_or_create_by(email: 'admin@example.com') do |u|
  u.password = 'password' 
  u.role = :admin
end
admin_wallet = admin.create_wallet!(balance: 1_000_000) rescue admin.wallet.update!(balance: 1_000_000)

user = User.find_or_create_by(email: 'user@example.com') do |u|
  u.password = 'password' 
end
user_wallet = user.create_wallet!(balance: 10_000) rescue user.wallet.update!(balance: 10_000)

