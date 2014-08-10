class AddStatusColumnToProposedWagers < ActiveRecord::Migration
  def change
    add_column :proposed_wagers, :status, :string
  end
end
