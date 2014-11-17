class ChangeCashedInDateToDatetime < ActiveRecord::Migration
  def up
    change_column :chips, :cashed_in_date, :datetime
  end

  def down
    change_column :chips, :cashed_in_date, :date
  end

end
