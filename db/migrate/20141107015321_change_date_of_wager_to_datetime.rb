class ChangeDateOfWagerToDatetime < ActiveRecord::Migration
  def change
    change_column :wagers, :date_of_wager, :datetime
  end
end
