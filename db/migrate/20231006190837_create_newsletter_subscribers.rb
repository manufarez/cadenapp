class CreateNewsletterSubscribers < ActiveRecord::Migration[7.0]
  def change
    create_table :newsletter_subscribers do |t|
      t.string :email, null: false, uniqueness: true
      t.datetime :unsubscribed_at
      t.string :ip_address
      t.string :user_agent
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
