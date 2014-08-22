class AddWinnerIdToProposedWagersTable < ActiveRecord::Migration
  def change
    add_column :proposed_wagers, :winner_id, :integer
  end
end
