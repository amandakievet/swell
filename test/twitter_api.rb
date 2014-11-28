=begin
I don't know what this file is, but it does not belong in this directory.
This directory is solely for test files - files containing tests that verify
the main logic of the application.

This looks like a command-line script, so it might belong in the bin directory
or it might belong as a rake task?
=end

require 'twitter'
require 'sentimental'
require 'indico'
require 'descriptive-statistics'



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

	tweets_text.flatten!

end

puts "Enter a search term"
hashtag = gets.chomp

search(hashtag, tweets_text, tweets)

Sentimental.load_defaults
analyzer = Sentimental.new

# Here i'm creating an array of hashes, and within each hash, is it's text and score. This way I can perform descriptive statistics on the array of scores.
@tweets = []
tweets_text.each_with_index do |tweet, i|
	score = analyzer.get_score(tweet)
	text = tweet
	index = i
	tweet = {
		:score => score,
		:id => index,
		:text => text
		}
	@tweets << tweet
end

# Here I want to create an array of scores so I can get - mean, std deviation and variance. This should tell us, disagreement within the sample, mean(average sentiment)

array_of_scores = []
@tweets.each do |tweet|
	array_of_scores << tweet[:score]
end

stats = DescriptiveStatistics::Stats.new(array_of_scores)




# Think of doing the more stressful tasks in a seperate AJAX call
{
	query: hashtag,
	score: aggregate_score,
	kurtosis: hashtag_kurtosis,
	relative_standard_deviation: hashtag_rsd,
	skewness: hashtag_skew
}







