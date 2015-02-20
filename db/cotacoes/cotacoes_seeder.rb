require 'date'

i = 0
File.readlines('COTA_SAMPLE.TXT').each do |line|
  i += 1
  next if i == 1
  date = Date.parse(line[2..9])
  ticker = line[12..23].delete(" ")
  price = ((line[108..120].to_f)/100).round(2)
  if Stock.find_by_ticker(ticker)
    Quote.create(price: price, datetime: date)
  end
end


