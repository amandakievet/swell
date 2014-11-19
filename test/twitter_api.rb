require 'twitter'


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

	first_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en")
	next_100_string = first_100_tweets[:search_metadata][:next_results]
	second_100_tweets = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{hashtag}&count=100&lang=en#{next_100_string}")

	y = first_100_tweets[:statuses].map {|status| status[:text]}
	k = second_100_tweets[:statuses].map {|status| status[:text]}
	tweets_text << y
	tweets_text << k

	tweets << first_100_tweets
	tweets << second_100_tweets
end
