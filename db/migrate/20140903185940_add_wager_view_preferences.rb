class AddWagerViewPreferences < ActiveRecord::Migration
  def change
    create_table :wager_view_preferences do |t|
      t.integer :wager_id
      t.integer :user_id
      t.boolean :show
    end
  end
end
