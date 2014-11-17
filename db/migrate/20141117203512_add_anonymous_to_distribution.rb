class AddAnonymousToDistribution < ActiveRecord::Migration
  def change
    add_column :distributions, :anonymous, :boolean
  end
end
