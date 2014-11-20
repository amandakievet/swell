class ApiSearcher
  def initialize(query)
    @query = query
    @consumer_key = ENV['CONSUMERKEY']
    @consumer_secret = ENV['CONSUMERSECRET']
    @access_token = ENV['ACCESSTOKEN']
    @access_token_secret = ENV['ACCESSTOKENSECRET']
  end

  def load_dictionary
    Sentimental.load_defaults
    Sentimental.threshold = 0.1
    @analyzer = Sentimental.new
  end

  def query
    @query
  end

  def sub!
    @query.gsub!(/#/, "\%23")
    @query.gsub!(/ /, "\%20")
  end

  def configure_twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = @consumer_key
      config.consumer_secret     = @consumer_secret
      config.access_token        = @access_token
      config.access_token_secret = @access_token_secret
    end
  end

  def make_request
    @client.get("https://api.twitter.com/1.1/search/tweets.json?q=#{@query}&count=100" )
  end

  def re_sub!
    @query.sub!(/%23/, "\#")
    @query.sub!(/%20/, "\ ")
  end

  def get_status_array
    result = self.make_request
    self.re_sub!
    status_array = result[:statuses]
    @tweets = []
    @tweet_bodies = status_array.map do |status|
      score = @analyzer.get_score status[:text]
      tweet = {
        :text  =>  status[:text],
        :score => score
      }
      @tweets<<tweet
    end
  end

  def calculate_sentiment_score
    scores = @tweets.map do |tweet|
      tweet[:score]
    end
    @score = scores.inject(0.0){ |sum, el| sum + el } / scores.size
    @score = (@score * 100).round(2) + 100
  end

  def process_request
    self.load_dictionary
    self.sub!
    self.configure_twitter_client
    self.get_status_array
    self.calculate_sentiment_score
  end
end