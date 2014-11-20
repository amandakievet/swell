class SearchesController < ApplicationController
  def new

  end

  def show
    Sentimental.load_defaults
    Sentimental.threshold = 0.1
    analyzer = Sentimental.new
    @query = params[:query]

    consumer_key = ENV['CONSUMERKEY']
    consumer_secret = ENV['CONSUMERSECRET']
    access_token = ENV['ACCESSTOKEN']
    access_token_secret = ENV['ACCESSTOKENSECRET']

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end

    result = client.get("https://api.twitter.com/1.1/search/tweets.json?q=%23#{@query}&count=100" )
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
    @score = (@score * 100).round(2) + 100
  end
end




