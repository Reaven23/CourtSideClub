class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :stripe_checkout_session_id
      t.string  :stripe_payment_intent_id
      t.string  :stripe_subscription_id
      t.string  :payment_status, default: "pending", null: false
      t.string  :fulfillment_status, default: "pending", null: false
      t.integer :total_cents, null: false

      t.timestamps
    end

    add_index :orders, :stripe_checkout_session_id, unique: true
    add_index :orders, :payment_status
    add_index :orders, :fulfillment_status
  end
end
