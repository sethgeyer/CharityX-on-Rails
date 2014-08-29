class RenameWagersIdColumnInNonRegisteredUsersColumn < ActiveRecord::Migration
  def change
    rename_column :non_registered_users, :wagers_id, :wager_id
  end
end
