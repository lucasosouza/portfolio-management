#cotacoes_parser.rb

cotacoes = []
File.readlines("COTAHIST_A2015.txt").each do |line|
  cotacao = line.match(/\d{12}([A-Z]{4}\d)\s*/)
  if cotacao
    cotacoes << cotacao[1]
  end
end

require 'nokogiri'
require 'open-uri'
require 'net/http'

module Net
    class HTTP
        alias old_initialize initialize

        def initialize(*args)
            old_initialize(*args)
            @read_timeout = 5     # 5 minutes
            @open_timeout = 5
        end
    end
end

module Bovespa
  class Cotacao

    attr_accessor :raw_attributes

    def initialize(nome_do_ativo)
      uri = URI.parse("http://www.bmfbovespa.com.br/cotacoes2000/formCotacoesMobile.asp?codsocemi=" + nome_do_ativo)
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.get("/cotacoes2000/formCotacoesMobile.asp?codsocemi=" + nome_do_ativo)
      end
      xml = Nokogiri::XML(res.body)
      raw_attr = {}
      xml.css("PAPEL").each do |node|
        @raw_attributes = node
      end
      create_attributes
    end

    def create_attributes
      attr_list = ["codigo", "delay", "data", "hora", "oscilacao", "valor_ultimo", "quant_neg", "mercado", "descricao"]
      attr_list.each do |method_name|
        self.instance_eval("def #{method_name}; @raw_attributes['#{method_name.upcase}']; end")
      end
    end

    def latest_value
      valor_ultimo
    end

    def ibovespa?
      if @raw_attributes['IBOVESPA'] == 'S'
        return true
      else
        return false
      end
    end

  end
end

# petr4 = Bovespa::Cotacao.new("PETR4")
# p petr4.latest_value

p cotacoes
i = 0
cotacoes_filtradas = []
cotacoes.uniq.each do |acao|
  i += 1
  puts i
  begin
    if Bovespa::Cotacao.new(acao).latest_value.to_f > 0
      cotacoes_filtradas << acao
    end
  rescue
    next
  end
end

puts cotacoes_filtradas
File.open("cotacoes_filtradas.txt", "w+") do |handler|
  cotacoes_filtradas.each { |acao| handler.puts acao }
end

