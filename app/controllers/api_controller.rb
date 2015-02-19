# api_controller.rb

before '/api/*' do
  content_type 'application/json'
end

post '/api/v1/buy' do
  transaction = Transaction.create(buy_quantity: params[:quantity].to_i, buy_price: params[:price].to_f, buy_datetime: DateTime.parse(params[:datetime]), index_id: 2, portfolio_id: current_portfolio.id, stock_id: params[:stock_id])
  status 200
  puts current_portfolio.transactions.map(&:export).to_json
  current_portfolio.transactions.map(&:export).to_json
end

post '/api/v1/sell' do
  message = Transaction.sell(params[:quantity].to_i, params[:price].to_f, DateTime.parse(params[:datetime]), current_portfolio.transactions.select { |t| t.stock.id == params[:stock_id].to_i })
  if message
    status 403
    { error: message }
  else
    status 200
    current_portfolio.transactions.map(&:export).to_json
  end
end

get '/api/v1/quotes' do
  status 200
  current_portfolio.transactions.map(&:export).to_json
end



