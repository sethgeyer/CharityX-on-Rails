class AddUuidToWagers < ActiveRecord::Migration
  def change
    add_column :wagers, :game_uuid, :string
  end
end
