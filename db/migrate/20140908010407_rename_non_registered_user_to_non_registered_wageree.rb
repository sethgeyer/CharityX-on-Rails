class RenameNonRegisteredUserToNonRegisteredWageree < ActiveRecord::Migration
  def change
    rename_table :non_registered_users, :non_registered_wagerees

  end
end
