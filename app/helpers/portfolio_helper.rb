
helpers do

  def full_portfolio
    current_portfolio.transactions.sort_by { |p| p.buy_datetime }.reverse
  end

  def current_portfolio
    Portfolio.find_by(id: session[:current_portfolio_id])
  end

  def update_quotes
    threads = []
    api_data = {}
    current_portfolio.transactions.each do |transaction|
        threads << Thread.new {
          begin
            api_data[transaction] = Bovespa::Cotacao.new(transaction.stock.ticker)
          rescue
            Thread.exit
          end
        }
    end
    threads.each { |th| th.join }
    api_data.each do |transaction, quote|
      transaction.stock.quotes.create(price: quote.latest_value, datetime: quote.datetime)
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

  def get_graph_data
    graph_data = []
    stocks_in_portfolio.uniq.each do |stock|
      quotes = stock.quotes.sort_by { |q| q.datetime }
      if quotes.first.datetime == Date.parse('2014-02-20')
        quotes.each do |quote|
          if quote.comparison_index
            graph_data << quote.export
          end
        end
      end
    end
    Stock.find(321).quotes.sort_by { |q| q.datetime }.each do |quote|
      graph_data << quote.export
    end
    save_to_file(graph_data)
  end

  def save_to_file(graph_data)
    CSV.open("public/files/stocks.csv", "wb") do |csv|
      csv << ["symbol","price","date"]
      graph_data.each do |data|
        csv << data
      end
    end
  end

  def get_tweets_data
    tweets = {}
    stocks_in_portfolio.uniq.each do |stock|
      tweets[stock.ticker] = TwitterApi.new.search_tweets(stock.ticker, 10)
    end
    tweets
  end

  def get_news_data
    news = {}
    stocks_in_portfolio.uniq.each do |stock|
      news[stock.ticker] = NewsAPI.new.search_news(stock.ticker)
    end
    news
  end

end

