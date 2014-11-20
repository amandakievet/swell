require 'twitter'
require 'sentimental'


# Guys these are my keys, appreciate if you replaced with your own
client = Twitter::REST::Client.new do |config|
	config.consumer_key    = "ZkpOurjZJkXoeRKTZB8Rm4nHW"
	config.consumer_secret = "nX3zVpmNilW39kfV1MhlhgKlZnOWM9Iif6l8uGOc327RTELw8o"
end

tweets_text = []
tweets = []

def search(hashtag, tweets_text, tweets)
	hashtag.downcase!
	client = Twitter::REST::Client.new do |config|
	config.consumer_key    = "ZkpOurjZJkXoeRKTZB8Rm4nHW"
	config.consumer_secret = "nX3zVpmNilW39kfV1MhlhgKlZnOWM9Iif6l8uGOc327RTELw8o"
	end

	a1_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en")
	next_100_string = a1_100_tweets[:search_metadata][:next_results]
	a2_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")
	next_100_string = a2_100_tweets[:search_metadata][:next_results]
	a3_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")
	next_100_string = a3_100_tweets[:search_metadata][:next_results]
	a4_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")
	next_100_string = a4_100_tweets[:search_metadata][:next_results]
	a5_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")
	next_100_string = a5_100_tweets[:search_metadata][:next_results]
	a6_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")
	next_100_string = a6_100_tweets[:search_metadata][:next_results]
	a7_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")
	next_100_string = a7_100_tweets[:search_metadata][:next_results]
	a8_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")
	next_100_string = a8_100_tweets[:search_metadata][:next_results]
	a9_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")
	next_100_string = a9_100_tweets[:search_metadata][:next_results]
	a10_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")



	a = a1_100_tweets[:statuses].map {|status| status[:text]}
	b = a2_100_tweets[:statuses].map {|status| status[:text]}
	c = a3_100_tweets[:statuses].map {|status| status[:text]}
	d = a4_100_tweets[:statuses].map {|status| status[:text]}
	e = a5_100_tweets[:statuses].map {|status| status[:text]}
	f = a6_100_tweets[:statuses].map {|status| status[:text]}
	g = a7_100_tweets[:statuses].map {|status| status[:text]}
	h = a8_100_tweets[:statuses].map {|status| status[:text]}
	i = a9_100_tweets[:statuses].map {|status| status[:text]}
	j = a10_100_tweets[:statuses].map {|status| status[:text]}

	tweets_text << a
	tweets_text << b
	tweets_text << c
	tweets_text << d
	tweets_text << e
	tweets_text << f
	tweets_text << g
	tweets_text << h
	tweets_text << i
	tweets_text << j


	binding.pry

	tweets_text.flatten!
	
end



 def show
    Sentimental.load_defaults
    Sentimental.threshold = 0.1
    analyzer = Sentimental.new
    query = params[:query]

   client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "ybFtYnXXu3jaMbWyX49xFnnFo"
      config.consumer_secret     = "loN3PdBiG7CfnQ5FqVVALLnCTdS9jEmIR9ocN1tE9q6HSQvElt"
      config.access_token        = "106548829-KXD9JL88mXnlxZ8snyDDMR33Vf0DNIoqxYoxAOYR"
      config.access_token_secret = "Q4hqgExFMSmZ1rUzi6GM5fValninOQMeDUHY4su97Xe1G"
   end
    result = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{query}&count=100" )
    status_array = result[:statuses]

    @tweets = []

   @tweet_bodies = status_array.map do |status|
      score = analyzer.get_score status[:text]
      tweet = {
        :text  =>  status[:text],
        :score => score
      }
      @tweets<<tweet
   end
   scores = @tweets.map do |tweet|
      tweet[:score]
   end
    @score = scores.inject(0.0){ |sum, el| sum + el } / scores.size
end
