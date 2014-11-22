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
    binding.pry
  end
end




