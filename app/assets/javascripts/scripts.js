function makeAPIRequest(){
	$.ajax({
		method: 'GET',
		url: '/searches/show',
		dataType: 'JSON',
		data: {query: $('#query').val()},
		success: processApiData
	});

	function processApiData(data){
		console.log(data);
		var query = data.query;
		var score = data.score;
		var sd = data.sd;
		var convo1 = data.convo1;
		var convo2 = data.convo2;
		var convo3 = data.convo3;
		var words = data.words;
		var userThumb = data.user_thumb;
		var username = data.username;
		var tweet = data.tweet;

		var source = $("#info-graphs").html();
		var template = Handlebars.compile(source);
		var data = {
			query: query,
			convo1: convo1,
			convo2: convo2,
			convo3: convo3,
			words: words,
			user_thumb: userThumb,
			username: username,
			tweet: tweet
		};
		$('#content-placeholder').html(template(data));

		thermometer(200, score, sd, true);
		buildCloud();
	};

	function buildCloud(){
		var settings = {
		"size" : {
			"grid" : 8,
			"factor": 5,
			"normalize": true
		},
		"options" : {
			"color" : "gradient",
			"printMultiplier" : 3
		},
		"color" : {
			"start" : "#fff",
			"end" : "#fff"
		},
		"font" : "'Montserrat', sans-serif",
		"shape" : "square"
		};

		$("#wordcloud").awesomeCloud(settings);
	};

}












