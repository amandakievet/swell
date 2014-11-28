class SearchesController < ApplicationController
require 'csv' # This is a code smell.
=begin
The only logic inside a controller should be to handle incoming data, pass it
off to an object that will do the real work, then return whatever data should
be returned in whatever format it should be returned. There should be no CSV
parsing, no JSON creating, nothing.
=end
  def new
    example_array = ["obamacare", "christmas", "The Graduate", "bunnies", "bacon", "puppies"]
    # Unless this is a placeholder for future logic, this is probably better
    # off in the front-end
    @example = example_array.sample
  end

  def show
    # Given that the HTML template for this action is empty,
    # I'm guessing we don't need any of those to be instance variables
    @query = params[:query]
    searcher = ApiSearcher.new(@query)
    stats_hash = searcher.process_request

    # All of this data formatting belongs in some method or object with the
    # sole responsibility of doing this work
    # See http://en.wikipedia.org/wiki/Single_responsibility_principle

    @score = searcher.manipulate_score(stats_hash[:mean])
    @sd = searcher.manipulate_sd(stats_hash[:sd])
    @words = stats_hash[:top_words]
    @convo1 = stats_hash[:convos][:first]
    @convo2 = stats_hash[:convos][:second]
    @convo3 = stats_hash[:convos][:third]

    @most_influential_icon = stats_hash[:most_influential].first[:profile_photo]
    @most_influential_user = stats_hash[:most_influential].first[:user_name]
    @most_influential_tweet = stats_hash[:most_influential].first[:text]

    respond_to do |format|
      format.html
      format.json { render :json => {
        query: @query,
        score: @score,
        sd: @sd,
        words: @words,
        convo1: @convo1,
        convo2: @convo2,
        convo3: @convo3,
        user_thumb: @most_influential_icon,
        username: @most_influential_user,
        tweet: @most_influential_tweet
        }}
    end

  end
end




