class CreateProductVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string  :size
      t.integer :stock, default: 0, null: false

      t.timestamps
    end

    add_index :product_variants, [:product_id, :size], unique: true
  end
end
