# api_controller.rb

before '/api/*' do
  content_type 'application/json'
end

post '/api/v1/buy' do
  transaction = Transaction.create(buy_quantity: params[:quantity].to_i, buy_price: params[:price].to_f, buy_datetime: DateTime.parse(params[:datetime]), index_id: 2, portfolio_id: current_portfolio.id, stock_id: params[:stock_id])
  get_graph_data
  status 200
  current_portfolio.transactions.map(&:export).to_json
end

post '/api/v1/sell' do
  message = Transaction.sell(params[:quantity].to_i, params[:price].to_f, DateTime.parse(params[:datetime]), current_portfolio.transactions.select { |t| t.stock.id == params[:stock_id].to_i })
  if message
    status 403
    { error: message }
  else
    get_graph_data
    status 200
    current_portfolio.transactions.map(&:export).to_json
  end
end

get '/api/v1/quotes' do
  get_graph_data
  status 200
  current_portfolio.transactions.map(&:export).to_json
end

get '/api/v1/tweets' do
  status 200
  get_tweets_data.to_json
end

get '/api/v1/news' do
  status 200
  get_news_data.to_json
end



