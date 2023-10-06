# Cadenapp

## Overview

Cadenapp is a web-based platform that enables users to securely form saving groups among peers, organize their savings collectively, and quickly distribute funds between each other.

## Tech Stack

The app is built using Ruby on Rails 7 (ruby 3.0.0), Tailwind CSS, Devise for authentication, Postmark for email notifications, AWS for image storage, Timecop for date simulation, Sidekiq for background jobs, HTML Beautifier, RuboCop for code style, Letter Opener for email simulation, Rack Mini Profiler, Bullet for performance monitoring, RSpec for testing, inline_svg to handle SVG rendering and some Stimulus / AlpineJS to bring interactivity on the client side (flash messages, modals, etc.).

## Setup

To run the Cadenapp locally, follow these steps:

1. Clone the repository to your local machine.

   ```bash
   git clone https://github.com/manufarez/cadenapp.git
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Create and initialize the database

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the server

   ```bash
   bin/dev
   ```

## Features

- **User management:** Users can create accounts, log in, and manage their profiles.
- **Cadena**: The app allows users to create and participate in savings groups called "Cadenas". When a user creates a Cadena, he becomes its administrator.
- **Participant interaction:** users can participate in a cadena via the Participant model. A user can have one unique participation in multiple Cadenas. Participants within a Cadena can interact with each other to save money together. Some Participants have a special administrator role `is_admin` that allows them to invite new participants, decide who will be part of the Cadena and randomly define the payment timeline.
- **Invitations:** through the Cadena's administrator, participants can invite others to join their Cadena.
- **Balance management and Payment processing**: each participant is able to deposit and withdraw money into their account. That balance is then used to perform transactions between participants. The app automatically calculates what a Participant owes to another on a given period.
- **Email Notifications:** Payment notifications and reminders are sent via email.
- **SuperAdmins :** Users that have a role of `is_admin` are able to access and CRUD all the User's informations, all the Cadena's informations and their Invitations.
- **Testing features** : see below.

## Database design

## Custom helpers

To help refactoring in some situations, we implemented an improvement on Rails' `link_to_if`method :

```ruby
def link_to_cond(condition, name, options = {}, html_options = {}, &block)
  if condition
    link_to(name, options, html_options, &block)
  elsif block
    block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options, &block)
  else
    ERB::Util.html_escape(name)
  end
end
```

## Testing features

### Impersonating users

A simple way to allow SuperAdmins to impersonate other users and have their POV. This makes `link_to login_as_user_path(@user)`handy.

```ruby
# ApplicationController
def login_as(user)
  sign_out(current_user) if current_user
  sign_in(user)
end
```

### Seeding and notifications

To avoid spending Postmark's e-mail credits, we added a `config.seeding = false` configuration on `application.rb`. Of course, this means we have to prepend our `seed.rb` file with:

```ruby
Rails.application.config.seeding = true
```

This is very useful because it allows us to disable notifications on some actions, for example :

```ruby
class Invitation < ApplicationRecord
  after_create :send_invitation_email, unless: -> { Rails.application.config.seeding }
  def send_invitation_email
    InvitationMailer.invite_email(self).deliver_now
  end
end
```

### The global_date selector

Because a Cadena evolves over time (different states, amounts, roles, etc.), we needed a way to quickly simulate time progression and test it on the fly. That's why we created the `global_date` selector. It basically allows to change the value of `Time.zone.now` based on a calendar. It relies on 3 parts:

1. On the backend, a set_date method on the ApplicationController allow us to 'travel time' thanks to the [Timecop gem](https://github.com/travisjeffery/timecop)

```ruby
def set_date
  Timecop.travel(params[:global_date])
  redirect_back(fallback_location: root_path, notice: t("notices.global_date", global_date: Time.zone.now.strftime('%d/%m/%Y')))
end
```

2. On the frontend, a simple date selector built with [Flatpickr](https://flatpickr.js.org/) allows the SuperAdmins to change the global_date by selecting dates on a datepicker

```erb
<%= form_with(url: set_date_path, method: :patch, data:{controller:'flatpickr'}, id:'global-date') do |form| %>
  <%= form.date_field :global_date, id:'date-input', class:'global_date', placeholder: Time.zone.now.strftime('%d/%m/%Y') %>
<% end %>
```

3. We use a small Stimulus controller to set `dateFormat`, `defaultDate` and `locale` as per Flatpickr's requirements.

**Caution :** some background jobs rely on `Time.zone.now`. You will not be able to future test them using our `global_date` selector because Sidekiq knows nothing about the Timecop's travel function, as it works with Redis commands, instead of the ruby environment.

## License

This project is licensed under the MIT License.

## Contact

For any questions or issues, please contact contacto@cadenapp.com.
