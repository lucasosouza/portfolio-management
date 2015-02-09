class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string   :ticker
      t.datetime :join_market_date
      t.datetime :left_market_date
      t.boolean  :preferential, default: true
      t.boolean  :index, default: false

      t.timestamps
    end
  end
end
