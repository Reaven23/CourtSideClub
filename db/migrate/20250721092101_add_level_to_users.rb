class AddLevelToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :level, null: true, foreign_key: true
  end
end
