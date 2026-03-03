class CreateRollCallEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :roll_call_entries do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps
    end
  end
end

