
helpers do

  def full_portfolio
    current_portfolio.transactions.sort_by { |p| p.buy_datetime }.reverse
  end

  def current_portfolio
    Portfolio.find_by(id: session[:current_portfolio_id])
  end

  def update_quotes
    current_portfolio.transactions.each do |transaction|
      begin
        quote = Bovespa::Cotacao.new(transaction.stock.ticker)
        transaction.stock.quotes.create(price: quote.latest_value, datetime: quote.datetime)
      rescue
        next
      end
    end
  end

  def all_stocks
    Stock.all.sort_by { |stock| stock.ticker }
  end

  def stocks_in_portfolio
    current_portfolio.transactions.map do |transaction|
      transaction.stock
    end
  end

end

