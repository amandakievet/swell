class SearchesController < ApplicationController

  def new
    example_array = ["obamacare", "christmas", "The Graduate", "bunnies", "bacon", "puppies"]
    @example = example_array.sample
  end

  def show
    searcher = ApiSearcher.new(params[:query])
    @query = searcher.query
    hash = searcher.process_request
    @score = hash[:mean]
  end
end




