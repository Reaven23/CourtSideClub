class MakeUserIdOptionalInNotifications < ActiveRecord::Migration[7.1]
  def change
    # Rendre user_id optionnel en supprimant la contrainte NOT NULL
    change_column_null :notifications, :user_id, true

    # Supprimer la contrainte de clé étrangère existante
    remove_foreign_key :notifications, :users

    # Recréer la clé étrangère avec la possibilité d'avoir des valeurs NULL
    add_foreign_key :notifications, :users, on_delete: :nullify
  end
end
