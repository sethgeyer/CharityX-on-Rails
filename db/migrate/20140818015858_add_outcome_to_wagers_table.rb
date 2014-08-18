class AddOutcomeToWagersTable < ActiveRecord::Migration
  def change
    add_column :proposed_wagers, "wagerer_outcome", :string
    add_column :proposed_wagers, "wageree_outcome", :string
  end
end
