SWELL

Amanda Kievet
Thareef Marzook
Peter Michalakis

================================================

Swell is a single-page web application designed for the curious social media user who wants a quick pulse of the internet's sentiment regarding a particular issue or event. 


The user enters a search term and Swell searches through Twitter, returning instances of that term, or hashtag, if a hashtag was searched for. 

https://cloud.githubusercontent.com/assets/8595204/5176167/a8da66cc-7412-11e4-9018-8fe3a5e7d5d7.png

Swell then analyzes the words in each Tweet in order to determine the positivity or negativity contained therein. Certain words are "scored," some having a positive value and some a negative value. These values are added together and the total is displayed in graphical form. 

https://cloud.githubusercontent.com/assets/8595204/5176169/aa636f0c-7412-11e4-81b5-5638bdc19ea8.png

The red arrow represents the mid-point of the graph, a perfectly neutral sentiment. The red bar indicates where along the spectrum the mean sentiment actually is. If the red bar ends before the red arrow, the general sentiment is negative, if past the red arrow, the sentiment is positive. The smaller, blue bar demonstrates the standard deviation of sentiment within the user's query. 

https://cloud.githubusercontent.com/assets/8595204/5176170/abb8a89a-7412-11e4-8358-ee90c61b5017.png

Swell also renders a word cloud, showing the words that most commonly appear alongside the searched term in relevant Tweets. The size of the word or term within the word cloud indicates its prevalence, the larger the word/term, the more times it has occurred.

