class AddColumnsToDistribution < ActiveRecord::Migration
  def change
    add_column :distributions, :check_number, :integer
    add_column :distributions, :date_cut, :datetime
    add_column :distributions, :cut_by, :string
  end
end
