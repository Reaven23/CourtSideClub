class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :object
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
