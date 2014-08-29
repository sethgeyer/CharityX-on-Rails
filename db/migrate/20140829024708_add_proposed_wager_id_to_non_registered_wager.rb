class AddProposedWagerIdToNonRegisteredWager < ActiveRecord::Migration
  def change
    add_column :non_registered_wagers, :proposed_wager_id, :integer
  end
end
