class RenameNonRegisteredWagerToNonRegisteredUser < ActiveRecord::Migration
  def change
    rename_table :non_registered_wagers, :non_registered_users
  end
end
