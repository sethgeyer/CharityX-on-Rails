class ChangeCharityColumnInDistributionTable < ActiveRecord::Migration
  def up
    add_column    :distributions, :charity_id, :integer
    remove_column :distributions, :charity, :string
    add_column    :distributions, :date, :date
  end

  def down
    remove_column :distributions, :charity_id
    add_column    :distributions, :charity, :string
    remove_column :distributions, :date
  end
end
