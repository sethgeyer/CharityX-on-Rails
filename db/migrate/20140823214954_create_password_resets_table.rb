class CreatePasswordResetsTable < ActiveRecord::Migration
  def change
    create_table :password_resets do |t|
      t.string :email
      t.string :unique_identifier
      t.date :expiration_date
    end
  end
end
