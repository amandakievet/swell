function makeAPIRequest(){
	$.ajax({
		url: '/searches/show',
		type: 'GET',
		data: {query: $('#query').val()},
		success: console.log(data)
	});
}