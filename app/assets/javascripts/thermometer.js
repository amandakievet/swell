// Much like the comments in ApiSearcher, thich would benefit from being
// a few smaller functions, easier to understand, test, maintain.
function thermometer(goalAmount, progressAmount, sdAmount, animate) {
	"use strict";
	var $thermo = $("#thermometer");
	var $progress = $(".progress");
	var $goal = $(".goal");
	var $sd = $(".sd");
	var percentageAmount;
	var sdMarginLeft;
	var sdMarginRight;
	var sdPercentageAmount;

    // What's the purpose of these three lines?
	goalAmount = goalAmount;
	progressAmount = progressAmount;
	sdAmount = sdAmount;
	percentageAmount = Math.min( Math.round(progressAmount / goalAmount * 1000)/10, 100);
    // What's "sd" ?
	sdPercentageAmount = Math.min( Math.round(sdAmount / goalAmount * 1000)/10, 100);
	sdMarginLeft = percentageAmount - ( 0.5 * sdPercentageAmount );
	sdMarginRight = ( 100 - percentageAmount ) - ( 0.5 * sdPercentageAmount );
	$sd.css("margin", "0 " + sdMarginRight + "% 0 " + sdMarginLeft + "%");
	$progress.find(".amount").hide();
	$sd.find(".amount").hide();


    // When you pass a boolean to a function, it's indicative that what you
    // really wanted to do was have two functions, one that does one thing,
    // one that does another. Again: single responsibility principle.

    // It seems like there's at least three or four functions here:
    // 1. Calculate the right data
    // 2. Do something with no animation
    // 3. Do something with animation
    // 4. A function that manages this at the top level
	if (animate !== false) {
		$progress.animate({
			"width": percentageAmount + "%"
		}, 1200, function(){
			$(this).find(".amount").fadeIn(500);
		});
		$sd.animate({
			"width": sdPercentageAmount + "%"
		}, 1200, function(){
			$(this).find(".amount").fadeIn(500);
		});
	} else {
		$progress.css({
			"height": percentageAmount + "%"
		});
		$progress.find(".amount").fadeIn(500);
		$sd.css({
			"height": sdPercentageAmount + "%"
		});
		$sd.find(".amount").fadeIn(500);
	}
}

