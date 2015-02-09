class Transaction < ActiveRecord::Base

  belongs_to :portfolio
  belongs_to :stock
  # has_one :stock, foreign_key: "index_id"

  def self.sell(qty, price, datetime, all_transactions)
    return "Not enough stocks in portfolio" if (all_transactions.map(&:available_stock).reduce(:+)) < qty

    all_transactions.sort_by { |t| t.buy_datetime }.each do |transaction|
      available_stock = transaction.available_stock
      if qty == 0
        break
      elsif available_stock == 0
        next
      elsif available_stock > qty
        transaction.update_attributes(sell_quantity: qty, sell_datetime: datetime, sell_price: price, buy_quantity: qty)
        Transaction.create(buy_quantity: (available_stock - qty), buy_price: transaction.buy_price, buy_datetime: transaction.buy_datetime, index_id: transaction.index_id, portfolio_id: transaction.portfolio_id, stock_id: transaction.stock_id)
        break
      elsif available_stock == qty
        transaction.update_attributes(sell_quantity: qty, sell_datetime: datetime, sell_price: price)
        break
      elsif transaction.available_stock < qty
        transaction.sell_quantity += available_stock
        transaction.sell_datetime = datetime
        transaction.sell_price = price
        transaction.save
        qty -= available_stock
      end
    end
  end

  def available_stock
    self.buy_quantity - self.sell_quantity
  end

  def sold?
    available_stock == 0
  end

  def initial_amount
    self.buy_quantity * self.buy_price
  end

  def final_amount
    self.sell_quantity * self.sell_price
  end

  def profit_or_loss
    final_amount - initial_amount
  end

  def profit?
    profit_or_loss >= 0
  end

  def valuation
    profit_or_loss / initial_amount
  end

  def formatted_valuation
   (valuation > 0 ? "+" : "") + ('%.2f' % valuation).to_s + "%"
  end




end
