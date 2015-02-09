class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.float     :price
      t.datetime  :datetime
      t.string    :source

      t.integer  :stock_id

      t.timestamps
    end
  end
end
