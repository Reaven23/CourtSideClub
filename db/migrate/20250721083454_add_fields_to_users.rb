class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :birthdate, :date
    add_column :users, :points, :integer, default: 0, null: false
  end
end
