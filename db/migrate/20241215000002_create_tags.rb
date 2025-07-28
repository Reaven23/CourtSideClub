class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :color, default: '#ee53a8'
      t.text :description

      t.timestamps
    end

    add_index :tags, :name, unique: true
  end
end
