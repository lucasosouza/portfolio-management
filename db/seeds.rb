File.readlines('db/cotacoes_filtradas.txt').each do |line|
  Stock.create(ticker: line.chomp)
end



