class ApiSearcher
  # require 'csv'
  # require 'twitter'
  # require 'sentimental'
  # require 'indico'
  # require 'descriptive-statistics'
  # attr_accessor :tweets_collection, :tweets_status, :results_hash, :tagging_hash, :largest_tag, :return_top_three_tags_keys, :tagging_sorted, :tags_hash, :array_of_scores
  def initialize(query)
    @query = query
    @consumer_key = ENV['CONSUMERKEY']
    @consumer_secret = ENV['CONSUMERSECRET']
    # @consumer_key = "ybFtYnXXu3jaMbWyX49xFnnFo"
    # @consumer_secret = "loN3PdBiG7CfnQ5FqVVALLnCTdS9jEmIR9ocN1tE9q6HSQvElt"
  end

  def load_dictionary
    Sentimental.load_defaults
    @analyzer = Sentimental.new
  end

  def query
    @query
  end

  def sub!
    @query.gsub!(/#/, "\%23")
    @query.gsub!(/ /, "\%20")
  end

  def configure_twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = @consumer_key
      config.consumer_secret     = @consumer_secret
    end
  end

  def make_request
    @client.get("https://api.twitter.com/1.1/search/tweets.json?q=#{@query}&count=100" )
  end

  def re_sub!
    @query.gsub!(/%23/, "\#")
    @query.gsub!(/%20/, "\ ")
  end

  def get_tweet_array
    @tweets_collection = []
    result = self.make_request
    i = 0
    while i < 3
      @tweets_collection << @client.get("https://api.twitter.com/1.1/search/tweets.json?q=#{@query}&count=100#{result[:search_metadata][:next_results]}")
      i += 1
    end
    self.re_sub!
  end

  def get_text_array
    @tweets_status = []
    @tweets_collection.map do |tweets_hash|
      tweets_hash[:statuses].map {|status| @tweets_status << status [:text]}
    end
  end

  def tweets_array_constructor
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
  def get_retweets_tweet_array
      @retweets_array = []
      @tweets_collection.map do |tweet_hash|
        tweet_hash[:statuses].map {|status|
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
      @retweets_array << retweets_hash}
      end
      @influence_sorted = @retweets_array.sort_by {|hash| -hash[:influence_score]}
   end
  def process_most_influential_users
    @most_influential = @influence_sorted.reject{|tweet| tweet[:text].include?("RT ")}.uniq{|tweet| tweet[:username]}
  end
  def construct_array_of_scores
    @array_of_scores = []
    @tweets_text_array.each do |tweet|
      @array_of_scores << tweet[:score]
    end
  end

  def construct_array_of_text
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
    self.load_dictionary
    self.sub!
    self.configure_twitter_client
    self.get_tweet_array
    self.get_text_array
    self.get_retweets_tweet_array
    self.tweets_array_constructor
    self.construct_array_of_scores
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
      :most_influential => self.process_most_influential_users
    }
  end


  def text_tagging
    @status_array = self.construct_array_of_text
    @tagging_hash = Indico.text_tags(@status_array)
  end

  def sort_text_tagging_hash
    @tagging_sorted = @tagging_hash.sort{ |a, b| b[1] <=> a[1]}
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

  def manipulate_sd(sd)
    (sd * 100) * 2
  end

  def text_counter_hash
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
      @word_counter_hash = @results.each_with_object(Hash.new(0)){ |word,counts| counts[word] +=1}
  end

  def return_top_ten_words
      self.tweets_array_constructor
      self.construct_array_of_text
      self.text_counter_hash
      @word_counter_sorted = @word_counter_hash.sort{|a,b| b[1] <=> a[1]}
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
  end
  def return_top_words_values
    self.return_top_ten_words
    @word_values_array = @word_count_hash.values.map do |word, number|
      number
    end
    @total_count = @word_values_array.inject{|sum,x| sum + x }
  end
  def calculate_percentages
    self.return_top_ten_words
    self.return_top_words_values
    @percents = @word_values_array.map do |word|
      (word / @total_count.to_f * 100).round(3)
    end
  end


end

