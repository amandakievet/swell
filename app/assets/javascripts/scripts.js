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
		renderThermometer(score, sd);
	};

	function renderThermometer(score, sd){
		var $section = $('.thermometer');
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
	};
}