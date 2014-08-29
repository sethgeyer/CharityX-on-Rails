class RenameProposedWagerIdInNonRegisteredWagers < ActiveRecord::Migration
  def change
    rename_column :non_registered_wagers, :proposed_wager_id, :wagers_id
  end
end
