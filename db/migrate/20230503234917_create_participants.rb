class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.references :cadena, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :withdrawal_date
      t.integer :position
      t.string :status
      t.integer :payments_expected
      t.integer :payments_received, default: 0
      t.decimal :total_due

      t.timestamps
    end
  end
end
