class ChangeColumnsInNonRegisteredUser < ActiveRecord::Migration
  def change
    rename_column :non_registered_users, :non_registered_user, :email
    remove_column :non_registered_users, :unique_id
  end
end
