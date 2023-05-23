class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.boolean :accepted, default: false
      t.references :cadena, null: false, foreign_key: true

      t.timestamps
    end
  end
end
