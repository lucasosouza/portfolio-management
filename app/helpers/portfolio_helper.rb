
helpers do

  def full_portfolio
    current_portfolio.transactions.sort_by { |p| p.buy_datetime }.reverse
  end

  def current_portfolio
    Portfolio.find_by(id: session[:current_portfolio_id])
  end

end


