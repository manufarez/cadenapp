class CreateParticipations < ActiveRecord::Migration[7.0]
  def change
    create_table :participations do |t|
      t.references :cadena, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :is_admin
      t.date :withdrawal_day
      t.integer :position
      t.string :status
      t.text :admin_notes

      t.timestamps
    end
  end
end
