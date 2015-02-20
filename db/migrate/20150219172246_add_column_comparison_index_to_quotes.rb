class AddColumnComparisonIndexToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :comparison_index, :float
  end
end
