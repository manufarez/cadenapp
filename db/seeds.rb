# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Participation.destroy_all
puts 'Participations destroyed!'
Invitation.destroy_all
puts 'Invitations destroyed!'
User.destroy_all
puts 'Users destroyed!'
Cadena.destroy_all
puts 'Cadenas destroyed!'

puts 'Creating 100 fake users...'
100.times do
  user = User.new
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name
  user.identification_number = Faker::IDNumber.valid
  user.identification_type = ['C.C.', 'C.I.', 'Passport'].sample
  user.identification_issued_at = Faker::Date.between(from: 10.years.ago, to: Date.today)
  user.sex = %w[M F].sample
  user.dob = Faker::Date.birthday(min_age: 18, max_age: 65)
  user.email = Faker::Internet.email
  user.password = user.email
  user.password_confirmation = user.password
  user.phone = Faker::PhoneNumber.cell_phone
  user.city = Faker::Address.city
  user.zip = Faker::Address.zip_code
  user.address = Faker::Address.street_address
  user.accepts_terms = true
  image = URI.parse('https://i.pravatar.cc/256').open
  user.avatar.attach(io: image, filename: 'avatar.png', content_type: 'image/png')
  user.save
  puts "User #{user.id} created!"
end

puts 'Creating 10 fake cadenas...'
10.times do
  cadena = Cadena.new
  cadena.name = Faker::Restaurant.name
  cadena.installments = 10
  cadena.installment_value = (200_000..1_000_000).step(100_000).to_a.sample
  cadena.start_date = Date.today
  cadena.end_date = Date.today + cadena.installments.months
  cadena.periodicity = 'monthly'
  cadena.balance = 0
  cadena.complete!
  cadena.save
  puts "Cadena #{cadena.id} created!"
end

puts 'Creating 10 fake participations for each cadena...'
users_in_groups_of_10 = User.all.each_slice(10).to_a
first_user_in_groups = users_in_groups_of_10.map { |group| group.first.id }
cadenas_ids = Cadena.all.ids

users_in_groups_of_10.each_with_index do |group, i|
  group.each do |user|
    participation = Participation.new
    participation.cadena_id = cadenas_ids[i]
    participation.user_id = user.id
    participation.is_admin = if first_user_in_groups.include?(participation.user_id)
                               true
                             else
                               false
                             end
    participation.save
    puts "Participation #{participation.id} created!"
  end
end

puts 'Creating invitations for each Cadena'
Cadena.all.each do |cadena|
  3..7.times do
    invitation = Invitation.new
    invitation.cadena_id = cadena.id
    invitation.sender_id = cadena.users.sample.id
    invitation.email = Faker::Internet.email
    invitation.phone = Faker::PhoneNumber.cell_phone
    invitation.first_name = Faker::Name.first_name
    invitation.last_name = Faker::Name.last_name
    invitation.accepted = false
    invitation.save
    puts "Invitation #{invitation.id} created!"
  end
end

puts "Creating Cadenapp's admins"
manu = User.new(first_name: 'Manuel', last_name: 'Farez', email: 'manufarez@gmail.com', password: '0$6t^^GCq9x4',
                is_admin: true)
manu.save
andre = User.new(first_name: 'André', last_name: 'Barreto', email: 'andre_barreto@hotmail.fr', password: 'Ubatexas2023!',
                 is_admin: true)
andre.save
puts "Cadenapp's admins created!"
