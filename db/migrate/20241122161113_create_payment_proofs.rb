class CreatePaymentProofs < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_proofs do |t|
      t.string :amount
      t.string :number
      t.string :account_type
      t.string :account_number
      t.datetime :transfer_timestamp
      t.string :bank_name
      t.references :cadena, null: false, foreign_key: true
      t.references :payment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
