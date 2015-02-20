# File.readlines('db/cotacoes_filtradas.txt').each do |line|
#   Stock.create(ticker: line.chomp)
# end

# require 'date'

# i = 0
# File.readlines('db/cotacoes/COTAHIST_A2014.TXT').each do |line|
#   i += 1
#   next if i == 1
#   begin
#     date = Date.parse(line[2..9])
#   rescue
#     next
#   end
#   ticker = line[12..23].delete(" ")
#   price = ((line[108..120].to_f)/100).round(2)
#   if stock = Stock.find_by_ticker(ticker)
#     Quote.create(price: price, datetime: date, stock_id: stock.id)
#   end
# end


stocks = Quote.pluck(:stock_id).uniq

stocks.each do |stock_id|
  base_quote = Quote.find_by(stock_id: stock_id, datetime: Date.parse('2014-02-20'))
  all_quotes = Quote.where(stock_id: stock_id).sort_by {|quote| quote.datetime}
  if base_quote
    base_price = base_quote.price
    all_quotes.each do |quote|
       quote.update_attributes(comparison_index: (quote.price/base_price))
    end
  end
end

Quote.where("datetime < :base_date", {base_date: Date.parse('2014-20-02')})
Quote.where("datetime = :base_date", {base_date: Date.parse('2014-20-02')})






