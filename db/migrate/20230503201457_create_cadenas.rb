class CreateCadenas < ActiveRecord::Migration[7.0]
  def change
    create_table :cadenas do |t|
      t.string :name
      t.integer :desired_participants
      t.integer :desired_installments
      t.decimal :saving_goal
      t.decimal :installment_value
      t.date :start_date
      t.date :end_date
      t.string :periodicity
      t.string :status
      t.decimal :balance
      t.boolean :approval_requested, default: false
      t.boolean :positions_assigned, default: false
      t.boolean :accepts_admin_terms
      t.timestamps
    end
  end
end
