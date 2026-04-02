class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string  :name, null: false
      t.integer :price_cents, null: false
      t.string  :product_type, null: false
      t.string  :stripe_price_id
      t.string  :stripe_product_id
      t.text    :description
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :products, :product_type
    add_index :products, :active
  end
end
