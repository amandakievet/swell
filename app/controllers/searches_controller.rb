class SearchesController < ApplicationController

  def new
    example_array = ["obamacare", "christmas", "The Graduate", "bunnies", "bacon", "puppies"]
    @example = example_array.sample
  end

  def show
    searcher = ApiSearcher.new(params[:query])
    @query = searcher.query
    stats_hash = searcher.process_request
    @score = searcher.manipulate_score(stats_hash[:mean])
    @sd = searcher.manipulate_sd(stats_hash[:sd])
    @words = stats_hash[:top_words]
    @convo1 = stats_hash[:convos][:first]
    @convo2 = stats_hash[:convos][:second]
    @convo3 = stats_hash[:convos][:third]
  end
end




