class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer   :buy_quantity, default: 0
      t.float     :buy_price, default: 0
      t.datetime  :buy_datetime

      t.integer   :sell_quantity, default: 0
      t.float     :sell_price, default: 0
      t.datetime  :sell_datetime

      t.integer   :index_id
      t.integer   :portfolio_id
      t.integer   :stock_id

      t.timestamps
    end
  end

end
