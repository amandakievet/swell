SWELL

Amanda Kievet
Thareef Marzook
Peter Michalakis

================================================

Swell is a single-page web application designed for the curious social media user who wants a quick pulse of the internet's sentiment regarding a particular issue or event. 


The user enters a search term and Swell searches through Twitter, returning instances of that term, or hashtag, if a hashtag was searched for. 

![Screenshot](https://cloud.githubusercontent.com/assets/8595204/5183899/f0f85522-7480-11e4-8cb5-f38a90cd7ffa.png)

Swell then analyzes the words in each Tweet in order to determine the positivity or negativity contained therein. Certain words are "scored," some having a positive value and some a negative value. These values are added together and the total is displayed in graphical form. 

![Screenshot](https://cloud.githubusercontent.com/assets/8595204/5183901/f49f7f70-7480-11e4-9915-75e8987813e5.png)

The red arrow represents the mid-point of the graph, a perfectly neutral sentiment. The red bar indicates where along the spectrum the mean sentiment actually is. If the red bar ends before the red arrow, the general sentiment is negative, if past the red arrow, the sentiment is positive. The smaller, blue bar demonstrates the standard deviation of sentiment within the user's query. 

![Screenshot](https://cloud.githubusercontent.com/assets/8595204/5183905/f9bed0be-7480-11e4-81cb-b0e1e16c7320.png)
Underneath the sentiment graph, Swell displays the "most influential" user, the user whose Tweet has generated the most retweets and/or has been favorited the most times, and the Tweet in question.


![Screenshot](https://cloud.githubusercontent.com/assets/8595204/5183980/8a585a8c-7481-11e4-8d4f-49349e6c7877.png)

Swell also renders a word cloud, showing the words that most commonly appear alongside the searched term in relevant Tweets. The size of the word or term within the word cloud indicates its prevalence, the larger the word/term, the more times it has occurred.


