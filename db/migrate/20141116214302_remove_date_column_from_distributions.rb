class RemoveDateColumnFromDistributions < ActiveRecord::Migration
  def change
    remove_column :distributions, :date, :date
  end
end
