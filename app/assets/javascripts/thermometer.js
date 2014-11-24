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
	
	goalAmount = goalAmount;
	progressAmount = progressAmount;
	sdAmount = sdAmount;
	percentageAmount = Math.min( Math.round(progressAmount / goalAmount * 1000)/10, 100);
	sdPercentageAmount = Math.min( Math.round(sdAmount / goalAmount * 1000)/10, 100);
	sdMarginLeft = percentageAmount - ( 0.5 * sdPercentageAmount );
	sdMarginRight = ( 100 - percentageAmount ) - ( 0.5 * sdPercentageAmount );
	$sd.css("margin", "0 " + sdMarginRight + "% 0 " + sdMarginLeft + "%");
	$progress.find(".amount").hide();
	$sd.find(".amount").hide();
	

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

