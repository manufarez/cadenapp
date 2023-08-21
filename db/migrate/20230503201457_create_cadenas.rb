class CreateCadenas < ActiveRecord::Migration[7.0]
  def change
    create_table :cadenas do |t|
      t.string :name
      t.integer :total_participants
      t.integer :installments
      t.decimal :saving_goal
      t.decimal :installment_value
      t.date :start_date
      t.date :end_date
      t.string :periodicity
      t.string :status
      t.decimal :balance
      t.timestamps
    end
  end
end
