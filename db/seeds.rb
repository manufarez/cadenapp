# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

time = Time.now
Participant.destroy_all
puts 'Participants destroyed!'
Invitation.destroy_all
puts 'Invitations destroyed!'
User.destroy_all
puts 'Users destroyed!'
Cadena.destroy_all
puts 'Cadenas destroyed!'

# Only uncomment this for the first installment, helps playing seeds faster
# require 'open-uri'
# 100.times do |i|
#   url = "https://i.pravatar.cc/256"
#   begin
#     file = URI.open(url)
#     File.open("public/avatars/avatar_#{i + 71}.png", 'wb') do |f|
#       f.write(file.read)
#     end
#     puts "#{url} downloaded"
#   rescue OpenURI::HTTPError => e
#     puts "Error downloading #{url}: #{e.message}"
#   end
# end

puts 'Creating 100 fake users...'
100.times do |i|
  email = Faker::Internet.email
  user = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    identification_number: Faker::IDNumber.valid,
    identification_type: ['C.C.', 'C.I.', 'Passport'].sample,
    identification_issued_at: Faker::Date.between(from: 10.years.ago, to: Date.today),
    sex: %w[M F].sample,
    dob: Faker::Date.birthday(min_age: 18, max_age: 65),
    email: email,
    password: email,
    password_confirmation: email,
    phone: Faker::PhoneNumber.cell_phone,
    city: Faker::Address.city,
    zip: Faker::Address.zip_code,
    address: Faker::Address.street_address,
    accepts_terms: true,
    balance: [0, 500000, 1000000, 5000000].sample
    )
    if Rails.env.production?
      image = URI.parse('https://i.pravatar.cc/256').open
      user.avatar.attach(io: image, filename: 'avatar.png', content_type: 'image/png')
    elsif Rails.env.development?
      user.avatar.attach(io: File.open("public/avatars/avatar_#{i}.png"), filename: 'avatar.png', content_type: 'image/png')
    end
  user.save!
  puts "User #{user.id} created"
end

puts 'Creating 10 fake cadenas...'
10.times do
  cadena = Cadena.new
  cadena.name = Faker::Restaurant.name
  cadena.desired_installments = 10
  cadena.desired_participants = 10
  cadena.installment_value = (200_000..1_000_000).step(100_000).to_a.sample
  cadena.start_date = Date.today
  cadena.end_date = Date.today + cadena.desired_installments.months
  cadena.periodicity = 'monthly'
  cadena.balance = 0
  cadena.save
  puts "Cadena #{cadena.id} created!"
end

puts 'Creating 10 fake participants for each cadena...'
users_in_groups_of_10 = User.all.each_slice(10).to_a
first_user_in_groups = users_in_groups_of_10.map { |group| group.first.id }
puts "#{first_user_in_groups}"
cadenas_ids = Cadena.all.ids

users_in_groups_of_10.each_with_index do |group, i|
  group.each do |user|
    participant = Participant.new
    participant.cadena_id = cadenas_ids[i]
    participant.user = user
    participant.is_admin = if first_user_in_groups.include?(participant.user_id)
                               true
                             else
                               false
                             end
    participant.save
    participant.errors
    puts "Participant #{participant.id} created!"
  end
end

puts "Delete and complete random participants to make it more realistic"
Participant.first(10).last.destroy
Participant.last.destroy
Cadena.all.map(&:save)
Cadena.where(status: 'complete').sample(4).each { |cadena| cadena.update(approval_requested: true, status: 'approval_requested') }
positions_assigned = Cadena.where(status: 'approval_requested').sample(2).each{|cadena| cadena.assign_positions}

puts 'Creating invitations for each Cadena'
Cadena.all.each do |cadena|
  cadena.users.each do |user|
    invitation = Invitation.new
    invitation.cadena = cadena
    invitation.sender = cadena.admin
    invitation.email = user.email
    invitation.phone = user.phone
    invitation.first_name = user.first_name
    invitation.last_name = user.last_name
    invitation.accepted = true
    invitation.save
  end
  5.times do
    invitation = Invitation.new
    invitation.cadena = cadena
    invitation.sender = cadena.users.sample
    invitation.email = Faker::Internet.email
    invitation.phone = Faker::PhoneNumber.cell_phone
    invitation.first_name = Faker::Name.first_name
    invitation.last_name = Faker::Name.last_name
    invitation.accepted = [false, nil].sample
    invitation.save
  end
  puts "Invitations created!"
  cadena.save
end

puts "Creating Cadenapp's admins"
manu = User.new(first_name: 'Manuel', last_name: 'Farez', email: 'manufarez@gmail.com', password: '0$6t^^GCq9x4',
                is_admin: true, sex: 'M', dob: '25/06/1990', identification_type: 'C.E', identification_number: '11AK70585', address: 'Cra. 14#13-12', city: 'Bogota', zip: '20212', phone: '2653543095', accepts_terms: true)
manu.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'zz.jpg')), filename: 'zz.jpg', content_type: 'image/jpeg')
manu.save

andre = User.new(first_name: 'André', last_name: 'Barreto', email: 'andre_barreto@hotmail.fr', password: 'Ubatexas2023!',
                 is_admin: true, sex: 'M', dob: '25/06/1990', identification_type: 'C.E', identification_number: '11AK70585', address: 'Cra. 14#13-12', city: 'Bogota', zip: '20212', phone: '2653543095', accepts_terms: true)
andre.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'r9.jpg')), filename: 'r9.jpg', content_type: 'image/jpeg')
andre.save
puts "Cadenapp's admins created!"
puts "Played seeds in #{Time.now - time} secs."
