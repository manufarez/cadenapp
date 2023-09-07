class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.string :token
      t.string :email
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.boolean :accepted
      t.references :cadena, null: false, foreign_key: true
      t.integer :sender_id, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
