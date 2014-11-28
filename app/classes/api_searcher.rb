# This is a model. It should be in the models directory.

class ApiSearcher

  # I'm deleting a whole bunch of commented-out stuff
  # Because Version Control is there to retrieve it
  # And because it makes MY comments harder to read otherwise.

  # Oh yeah and commenting out API keys still leaves them in source control
  # You should delete those and create new ones.

  # There are too many methods in this object. Many things calculating many
  # other things. It would be easier to test and maintain if there were
  # smaller objects each just doing one thing.
  def initialize(query)
    @query = query # Arguably, this
    @consumer_key = ENV['CONSUMERKEY']
    @consumer_secret = ENV['CONSUMERSECRET']
  end

  def dictionary
    Sentimental.load_defaults
    @analyzer = Sentimental.new
  end

  def query
    @query
  end

  def clean_up_query!
    @query.gsub!(/#/, "\%23")
    @query.gsub!(/ /, "\%20")
  end

  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = @consumer_key
      config.consumer_secret = @consumer_secret
    end
  end

  def search
    @client.get("https://api.twitter.com/1.1/search/tweets.json?q=#{@query}&count=100")
  end

  # That's the best name I could come up with. It's unclear why this
  # needs to happen
  def clean_up_query_again!
    @query.gsub!(/%23/, "\#")
    @query.gsub!(/%20/, "\ ")
  end

  def tweets
    @tweets_collection = []
    result = self.search
    i = 0
    while i < 3
      @tweets_collection << @client.get("https://api.twitter.com/1.1/search/tweets.json?q=#{@query}&count=100#{result[:search_metadata][:next_results]}")
      i += 1
    end
    self.clean_up_query_again!
  end

  def tweet_texts
    @tweets_status = []
    @tweets_collection.map do |tweets_hash|
      tweets_hash[:statuses].map { |status| @tweets_status << status [:text] }
    end
  end

  def default_values_for_tweets
    # This is odd. You should probably pass in the @tweets_status instead of
    # just taking advantage of the instance variable.
    # The way you have it makes the code hard to test and hard to maintain.

    @tweets_text_array = []
    @tweets_status.each_with_index do |tweet, i|
      score = @analyzer.get_score(tweet)
      text = tweet
      id = i
      tweet = {
        :score => score,
        :id => id,
        :text => text
      }
      @tweets_text_array << tweet
    end
  end

  def retweets
    @retweets_array = []
    @tweets_collection.map do |tweet_hash|
      tweet_hash[:statuses].map { |status|
        retweets_hash = {
          :text => status[:text],
          :created_at => status[:created_at],
          :retweets => status[:retweet_count],
          :user_name => status[:user][:name],
          :twitter_page => "https://twitter.com/#{status[:user][:screen_name]}",
          :followers_count => status[:user][:followers_count],
          :profile_photo => status[:user][:profile_image_url],
          :score => @analyzer.get_score(status[:text]),
          :influence_score => (((status[:retweet_count] * 5) * status[:user][:followers_count])/1000)
        }
        @retweets_array << retweets_hash }
    end
    @influence_sorted = @retweets_array.sort_by { |hash| -hash[:influence_score] }
  end

  def most_influential_users
    @most_influential = @influence_sorted.
      reject { |tweet| tweet[:text].include?("RT ") }.
      uniq { |tweet| tweet[:username] }
  end

  def tweet_scores
    @array_of_scores = []
    @tweets_text_array.each do |tweet|
      @array_of_scores << tweet[:score]
    end
  end

  def texts
    @array_of_text = []
    @tweets_text_array.each do |tweet|
      @array_of_text << tweet[:text]
    end
    @array_of_text.join
  end

  def desc_statistics_init
    @stats = DescriptiveStatistics::Stats.new(@array_of_scores)
  end

  def statistic_mean
    @stats.mean
  end

  def statistic_kurtosis
    @stats.kurtosis
  end

  def statistic_relative_standard_deviation
    @stats.standard_deviation
  end

  def statistic_standard_deviation
    @stats.standard_deviation
  end

  def statistic_mode
    @stats.mode
  end

  def statistic_skewness
    @stats.skewness
  end

  def statistic_median
    @stats.median
  end

  def process_request
    # After having renamed the methods, this looks silly. Instead of creating
    # the methods and just giving them one-off methods, you can construct a
    # language of objects and have them talk to each other
    # The code is put together in a pseudo-functional way, which would be
    # great if it didn't rely entirely on the state of the object.
    # In other words: either use objects and you're allowed to rely on state,
    # or create a functional program and hold no state whatsoever, pass
    # everything you need into every function that needs it.

    # This code, as it stands, it entirely coupled to everything else, and it
    # is very difficult to take any of this logic and move it to another object
    self.dictionary
    self.clean_up_query!
    self.twitter_client
    self.tweets
    self.tweet_texts
    self.retweets
    self.default_values_for_tweets
    self.tweet_scores
    self.desc_statistics_init
    {
      :mean => self.statistic_mean,
      :median => self.statistic_median,
      :mode => self.statistic_mode,
      :rsd => self.statistic_relative_standard_deviation,
      :sd => self.statistic_standard_deviation,
      :kurtosis => self.statistic_kurtosis,
      :skewness => self.statistic_skewness,
      :top_words => self.return_top_ten_words,
      :word_total => self.return_top_words_values,
      :percents => self.calculate_percentages,
      :convos => self.return_top_three_tags,
      :most_influential => self.most_influential_users
    }
  end


  def text_tagging
    @status_array = self.texts
    @tagging_hash = Indico.text_tags(@status_array)
  end

  def sort_text_tagging_hash
    @tagging_sorted = @tagging_hash.sort { |a, b| b[1] <=> a[1] }
  end

  def return_top_three_tags
    self.text_tagging
    self.sort_text_tagging_hash
    @first_tag = @tagging_sorted[0][0]
    @second_tag = @tagging_sorted[1][0]
    @third_tag = @tagging_sorted[2][0]
    @tags_hash = {
      :first => @first_tag,
      :second => @second_tag,
      :third => @third_tag
    }
  end

  def manipulate_score(score)
    (score * 100) + 100
  end

  # What's SD? And of course we're manipulating it. What is this method giving
  # us?
  def manipulate_sd(sd)
    (sd * 100) * 2
  end

  def text_counter_hash
    # Reading a file? This almost guarantees that this method should be in
    # another object
    @excluded_as_arrays = CSV.read("app/assets/exclusions.csv")
    @excluded_as_one_array = @excluded_as_arrays.map { |word| word[0] }
    @array_split = @array_of_text.join.split(" ")
    @results = []
    @removed = []
    @exclusions = @excluded_as_one_array.each { |word| word }
    @array_split.each do |x|
      exclude = false
      @exclusions.each do |y|
        if x == y || x == @query || x == @query.downcase || x == @query.capitalize || x == @query.upcase || x == "#" + @query || x == @query + "'s" || x == @query + "," || x == @query + ":"
          exclude = true
          @removed << x
        end
      end
      if !exclude
        @results << x
      end
    end
    @word_counter_hash = @results.each_with_object(Hash.new(0)) { |word, counts| counts[word] +=1 }
  end

  def return_top_ten_words
    self.default_values_for_tweets
    self.texts
    self.text_counter_hash
    # How many of these absolutely need to be instance variables?
    @word_counter_sorted = @word_counter_hash.sort { |a, b| b[1] <=> a[1] }
    @first_word = @word_counter_sorted[0]
    @second_word = @word_counter_sorted[1]
    @third_word = @word_counter_sorted[2]
    @fourth_word = @word_counter_sorted[3]
    @fifth_word = @word_counter_sorted[4]
    @sixth_word = @word_counter_sorted[5]
    @seventh_word = @word_counter_sorted[6]
    @eigth_word = @word_counter_sorted[7]
    @ninth_word = @word_counter_sorted[8]
    @tenth_word = @word_counter_sorted[9]
    @word_count_hash = {
      :first => @first_word,
      :second => @second_word,
      :third => @third_word,
      :fourth => @fourth_word,
      :fifth => @fifth_word,
      :sixth => @sixth_word,
      :seventh => @seventh_word,
      :eigth => @eigth_word,
      :ninth => @ninth_word,
      :tenth => @tenth_word,
    }
    @word_count_array = [@first_word, @second_word, @third_word, @fourth_word, @fifth_word, @sixth_word, @seventh_word, @eigth_word, @ninth_word, @tenth_word]
  end

  def return_top_words_values
    self.return_top_ten_words
    @word_values_array = @word_count_hash.values.map do |word, number|
      number
    end
    @total_count = @word_values_array.inject { |sum, x| sum + x }
  end

  def calculate_percentages
    self.return_top_ten_words
    self.return_top_words_values
    @percents = @word_values_array.map do |word|
      (word / @total_count.to_f * 100).round(3)
    end
  end


end

