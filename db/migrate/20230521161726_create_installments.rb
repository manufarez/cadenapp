class CreateInstallments < ActiveRecord::Migration[7.0]
  def change
    create_table :installments do |t|
      t.date :date
      t.integer :transactions_expected
      t.integer :transactions_made
      t.decimal :total_due
      t.decimal :total_paid
      t.integer :position
      t.bigint :account_id
      t.string :status
      t.string :debitors
      t.string :creditors
      t.float :installment_fee
      t.integer :installment_number

      t.timestamps
    end
  end
end
