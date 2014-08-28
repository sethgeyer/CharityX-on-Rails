class CreateNonRegisteredWagers < ActiveRecord::Migration
  def change
    create_table :non_registered_wagers do |t|
      t.string :unique_id
      t.string :non_registered_user
    end
  end
end
