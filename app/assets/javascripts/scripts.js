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
	};
}