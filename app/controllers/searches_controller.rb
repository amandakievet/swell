class SearchesController < ApplicationController
  def new

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
    @score = (@score * 100).round(2)
  end
end




