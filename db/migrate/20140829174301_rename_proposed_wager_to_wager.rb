class RenameProposedWagerToWager < ActiveRecord::Migration
  def change
    rename_table :proposed_wagers, :wagers
  end
end
