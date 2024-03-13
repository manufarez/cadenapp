Rails.application.config.seeding = true
# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
# #   Character.create(name: "Luke", movie: movies.first)

time = Time.now

Participant.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!(Participant.table_name)
puts 'Participants destroyed!'
Invitation.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!(Invitation.table_name)
puts 'Invitations destroyed!'
User.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!(User.table_name)
puts 'Users destroyed!'
Cadena.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!(Cadena.table_name)
puts 'Cadenas destroyed!'
Payment.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!(Payment.table_name)
puts 'Payments destroyed!'

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

puts 'Creating 170 fake users...'
170.times do |i|
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

puts 'Creating 10 fake cadenas with 10 participants...'
17.times do |i|
  cadena = Cadena.new
  cadena.name = Faker::Restaurant.name
  cadena.desired_installments = 10
  cadena.desired_participants = 10
  cadena.installment_value = (200_000..1_000_000).step(100_000).to_a.sample
  cadena.saving_goal = cadena.desired_installments * cadena.installment_value
  cadena.start_date = Date.today + 1.day
  cadena.periodicity = ['monthly', 'bimonthly', 'daily'].sample
  puts cadena.periodicity
  periodicity_multiplier = case cadena.periodicity
                           when 'monthly' then 1.month
                           when 'bimonthly' then 15.days
                           when 'daily' then 1.day
                           end
  cadena.end_date = cadena.start_date + (cadena.desired_installments * periodicity_multiplier) - 1.day
  puts cadena.end_date.strftime('%d/%m/%Y')
  cadena.accepts_admin_terms = true
  if cadena.valid?
    cadena.save
  else
    puts cadena.errors.full_messages.join(', ')
    return
  end
  puts "Cadena #{cadena.id} created with status #{cadena.state}"
end

puts "Creating 10 participants for each cadena..."
counter = 0
Cadena.all.each do |cadena|
  counter += 1
  cadena.admin = Participant.create(user: User.find(counter), cadena: cadena)
  cadena.save
  9.times do
    counter += 1
    Participant.create(user: User.find(counter), cadena: cadena)
  end
end

puts "Change cadena's states to make it more realitic"

# Make 7 of the cadenas complete
complete_cadenas = Cadena.all.sample(7).each { |cadena| cadena.complete }
# Make 4 of them be participants_approval
participants_approval = complete_cadenas.sample(5).each { |cadena| cadena.approve_participants }
# Start 3 of them
participants_approval.sample(3).each{|cadena| cadena.start}
# The rest is pending so we delete users
Cadena.where(state:'pending').each{ |cadena| cadena.participants.last.destroy }

puts 'Creating invitations for each Cadena'
Cadena.all.each do |cadena|
  cadena.users.each do |user|
    invitation = Invitation.new
    invitation.cadena = cadena
    invitation.sender = cadena.admin.user
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

@cadena = Cadena.where(state: 'started').first
puts "Advancing the progression of Cadena #{@cadena.id}"

# Makes some fake payments
@cadena.participants_except_next_paid.each do |participant|
  @payment = Payment.new(
    cadena: @cadena,
    participant: @cadena.next_paid_participant,
    amount: @cadena.installment_value,
    user: participant.user,
    paid_at: Time.zone.now
  )
  if @payment.valid?
    @payment.save
  else
    puts @payment.errors.full_messages.join(', ')
    # return
  end
end

puts "There are :\n - #{User.all.count} users\n - #{Participant.all.count} participants \n - #{Invitation.all.count} invitations \n - #{Cadena.all.count} cadenas \n - #{Payment.all.count} payments"
puts "Played seeds in #{Time.now - time} secs."
Rails.application.config.seeding = false
