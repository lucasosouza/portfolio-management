#create a portfolio and an user
User.create(username: "lucasosouza", email: "lucasosouza@gmail.com", password: "abc123", phone: "415-6297036")
Portfolio.create(name: "bovespa_portfolio" , user_id: 1 )

#create Petrobras and Bovespa stocks
Stock.create(ticker: "PETR4" )
Stock.create(ticker: "BOVESPA", index: true)

#create a buy and sell transaction for petrobras
Transaction.create(buy_quantity: 200, buy_price: 25.0, buy_datetime: DateTime.new(2015,2,1), index_id: 2, portfolio_id: 1 , stock_id: 1)
Transaction.create(buy_quantity: 300, buy_price: 26.0, buy_datetime: DateTime.new(2015,2,2), index_id: 2, portfolio_id: 1 , stock_id: 1)

#create quote prices for Petrobras
Quote.create(price: 25.0, datetime: DateTime.new(2015,2,1), stock_id: 1)
Quote.create(price: 25.5, datetime: DateTime.new(2015,2,2),stock_id: 1)
Quote.create(price: 26.5, datetime: DateTime.new(2015,2,3), stock_id: 1)

#create quote prices for Bovespa
Quote.create(price: 100.0, datetime: DateTime.new(2015,2,1), stock_id: 2)
Quote.create(price: 101.0, datetime: DateTime.new(2015,2,2),stock_id: 2)
Quote.create(price: 102.0, datetime: DateTime.new(2015,2,3), stock_id: 2)
