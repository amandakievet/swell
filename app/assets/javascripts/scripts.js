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
		renderThermometer(score, sd, convo1, convo2, convo3);
		renderWordCloud(words);
	};

	function renderThermometer(score, sd, c1, c2, c3){
		var $section = $('.thermometer');
		$section.empty();
		var $contentDiv = $("<div>", {id: "content"});
		var $thermDiv = $("<div>", {id: "thermometer"});
		var $trackDiv = $("<div>", {class: "track"});

		var $goalDiv = $("<div>", {class: "goal"});
		var $goalAmountDiv = $("<div>", {class: "amount"});
		$goalDiv.append($goalAmountDiv);

		var $progressDiv = $("<div>", {class: "progress"});
		var $progressAmountDiv = $("<div>", {class: "amount"});
		$progressDiv.append($progressAmountDiv);

		var $sdDiv = $("<div>", {class: "sd"});
		var $sdAmountDiv = $("<div>", {class: "amount"});
		$sdDiv.append($sdAmountDiv);

		$trackDiv.append($goalDiv);
		$trackDiv.append($progressDiv);
		$trackDiv.append($sdDiv);
		$thermDiv.append($trackDiv);
		$contentDiv.append($thermDiv);

		$section.append($contentDiv);
		thermometer(200, score, sd, true);

		var $middleMarker = $("<div>", {id: "triangle"});
		$contentDiv.append($middleMarker);

		var $convoDiv = $("<div>", {id: "conversation"});
		var $convoText = $("<h6>The conversation is taking place in these categories:</h6><h4>" + c1 + ", " + c2 + ", " + c3 + "</h4>");
		$convoDiv.append($convoText);

		$contentDiv.append($convoDiv);

		var $arrowDiv = $("<div>", {class: "arrow animated bounce"});
		$contentDiv.append($arrowDiv);
	};

	function renderWordCloud(words){
		var $wordCloudSection = $(".wordcloud");
		$wordCloudSection.empty();
		var $wordCloudDiv = $("<div>", {id: "wordcloud"});
		$(words).each(function(idx,word){
			var $wordSpan = $("<span>" + word[0] + "</span>");
			$wordSpan.attr("data-weight", word[1]);
			$wordCloudDiv.append($wordSpan);
		});
		$wordCloudSection.append($wordCloudDiv);

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










