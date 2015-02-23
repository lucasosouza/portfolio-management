class TwitterApi
HP_API_KEY = "b0242e0e-5ea4-4a35-a5b8-300e01bcaef1"

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "nWLrwMSzsr2cwFGcd1OWjrdTD"
      config.consumer_secret     = "pxIyS3U7GfENhkl8EqaRGtDi74mSrcS9BRGfDVHZTJ4CpBVbww"
      config.access_token        = "187605500-jDYqzCQ3D4uEK6SwnUyjOltNWpDq3CvRtgjtGQVJ"
      config.access_token_secret = "YzfqI59LF09APtzKFfvxgp4QNBk2GTj9EjkeUm7mkqhNa"
    end
  end

  def search_tweets(stock, count)
    search_params = ["#{stock} -rt", result_type: "recent", lang: "pt"]
    tweets = @client.search(*search_params).take(count).map do |tweet|
      "#{tweet.text.sub('\n','')} - #{tweet.user.screen_name}" unless tweet.text.match(/http/)
    end
    overall_score = analyse(tweets.compact)
    tweets.compact.unshift(overall_score)
  end

  def sentiment_analysis(sentence)
    open("https://api.idolondemand.com/1/api/sync/analyzesentiment/v1?apikey=#{HP_API_KEY}&language=por&text=#{URI::encode(sentence)}").read
  end

  def sentiment_score(sentence)
    analysis = JSON.parse sentiment_analysis(sentence.chomp)
    p analysis["aggregate"]["score"]
  end

  def analyse(tweets)
    sum_score = tweets.reduce(0) do |sum, tweet|
      sum + sentiment_score(tweet)
    end
    begin
      sum_score / tweets.count
    rescue
      0
    end
  end

end
