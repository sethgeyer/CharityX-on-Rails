class CreateCharitiesTable < ActiveRecord::Migration
  def up
    create_table :charities do |t|
      t.string :name
      t.integer :tax_id
      t.string :poc
      t.string :poc_email
      t.string :status
    end
  end

  def down
    drop_table :charities
  end
end
