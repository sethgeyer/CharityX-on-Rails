class AddSportsGameOutcomes < ActiveRecord::Migration
  def change
    create_table :sports_games_outcomes do |t|
      t.string :game_uuid
      t.string :home_id
      t.integer :home_score
      t.string :vs_id
      t.integer :vs_score
      t.string  :status
      t.integer :quarter
      t.string  :clock
    end
  end
end
