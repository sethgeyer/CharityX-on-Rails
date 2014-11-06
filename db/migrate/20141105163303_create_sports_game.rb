class CreateSportsGame < ActiveRecord::Migration
  def change
    create_table :sports_games do |t|

      t.string  :uuid
      t.datetime :date
      t.integer :nfl_week
      t.string  :home_id
      t.string  :vs_id
      t.string  :status
      t.string  :venue
      t.string  :temperature
      t.string  :condition

    end
  end
end
