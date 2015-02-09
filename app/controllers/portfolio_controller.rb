get '/portfolio' do
  erb :portfolio
end

post '/buy' do
  Transaction.create(buy_quantity: params[:quantity].to_i, buy_price: params[:price].to_f, buy_datetime: DateTime.parse(params[:datetime]), index_id: 2, portfolio_id: current_portfolio.id, stock_id: params[:stock_id])
  redirect '/portfolio'
end

post '/sell' do
  message = Transaction.sell(params[:quantity].to_i, params[:price].to_f, DateTime.parse(params[:datetime]), current_portfolio.transactions.select { |t| t.stock.id == params[:stock_id].to_i })
  if message
    redirect '/portfolio', error: message
  else
    redirect '/portfolio'
  end
end
