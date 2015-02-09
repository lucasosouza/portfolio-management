# error_helper.rb

class TransactionError < StandardError
end

error TransactionError do
  redirect '/portfolio', error: "Not enough stocks in portfolio"
end