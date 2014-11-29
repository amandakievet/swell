// This function needs a better name, like "gatherTweetData", if that's what it
// does
function makeAPIRequest() {
    $.ajax({
        method: 'GET',
        url: '/searches/show',
        dataType: 'JSON',
        data: {query: $('#query').val()},
        success: processApiData
    });

    // This function needs a better name, like "showResults"
    // Once it has a name like that, it's a little clearer that we need a few
    // functions again, like you have here to build the cloud and the
    // thermometer,
    // but I also see that we're doing template rendering, which
    // belongs in its own function (presentation is a separate concern).
    function processApiData(data) {
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

        // It looks like you're rebuilding the data object
        // Am I wrong? Why are you doing that?

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
        var html = $('#content-placeholder').html(template(data));
        $(html).find(".stats-info a").on("click", function (e) {
            $(this).next().slideToggle();
        });


        thermometer(200, score, sd, true);
        buildCloud();
    }

    function buildCloud() {
        var settings = {
            "size": {
                "grid": 8,
                "factor": 5,
                "normalize": true
            },
            "options": {
                "color": "gradient",
                "printMultiplier": 3
            },
            "color": {
                "start": "#fff",
                "end": "#fff"
            },
            "font": "'Montserrat', sans-serif",
            "shape": "square"
        };

        $("#wordcloud").awesomeCloud(settings);
    }

}












