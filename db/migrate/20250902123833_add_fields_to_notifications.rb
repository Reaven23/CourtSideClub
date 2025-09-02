class AddFieldsToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :phone, :string
    add_column :notifications, :first_name, :string
    add_column :notifications, :last_name, :string
    add_column :notifications, :company, :string
    add_column :notifications, :email, :string
  end
end
