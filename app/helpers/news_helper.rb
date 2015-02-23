# news_helper.rb

class NewsAPI
WEBHOSE_TOKEN = "848c2651-302f-49ff-bc7d-0e4194a99b6a"

  def latest_news(stock)
    open("https://webhose.io/search?token=#{WEBHOSE_TOKEN}&format=json&q=#{stock}").read
  end

  def search_news(stock)
    headlines = JSON.parse(latest_news(stock))["posts"]
    hash = {}
    headlines.each do |headline|
      if headline["language"] == "portuguese"
        hash[headline["title"]] = headline["url"]
      end
    end
    hash
  end

end


