class CreatePaymentRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_requests do |t|
      t.integer :amount_in_cents, null: false
      t.string :currency, null: false, limit: 3
      t.text :description
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
