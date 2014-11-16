class RemoveColumnsFromChips < ActiveRecord::Migration
  def change
    remove_column :chips, :l1_tag_id, :string
    remove_column :chips, :l2_tag_id, :string
    remove_column :chips, :purchase_date, :date

  end
end
