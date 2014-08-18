class AddTimestampColumnsToEachTable < ActiveRecord::Migration
  def change
    add_column(:accounts, :created_at, :datetime)
    add_column(:accounts, :updated_at, :datetime)

    add_column(:charities, :created_at, :datetime)
    add_column(:charities, :updated_at, :datetime)

    add_column(:chips, :created_at, :datetime)
    add_column(:chips, :updated_at, :datetime)

    add_column(:deposits, :created_at, :datetime)
    add_column(:deposits, :updated_at, :datetime)

    add_column(:distributions, :created_at, :datetime)
    add_column(:distributions, :updated_at, :datetime)

    add_column(:mvps, :created_at, :datetime)
    add_column(:mvps, :updated_at, :datetime)

    add_column(:proposed_wagers, :created_at, :datetime)
    add_column(:proposed_wagers, :updated_at, :datetime)

    add_column(:users, :created_at, :datetime)
    add_column(:users, :updated_at, :datetime)
  end
end
