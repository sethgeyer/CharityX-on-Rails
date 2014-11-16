class RemoveExtraColumnsInDeposits < ActiveRecord::Migration
  def change
    remove_column :deposits, :date_created, :date
    remove_column :deposits, :cc_number, :integer
    remove_column :deposits, :exp_date, :integer
    remove_column :deposits, :name_on_card, :string
    remove_column :deposits, :cc_type, :string
  end
end
