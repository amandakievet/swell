function thermometer(goalAmount, progressAmount, sdAmount, animate) {
	"use strict";

	var $thermo = $("#thermometer"),
			$progress = $(".progress", $thermo),
			$goal = $(".goal", $thermo),
			$sd = $(".sd", $thermo),
			percentageAmount,
			sdMarginLeft,
			sdMarginRight,
			sdPercentageAmount;

	goalAmount = goalAmount || parseFloat($goal.find(".amount").data("amount"));
	progressAmount = progressAmount || parseFloat($progress.find(".amount").data("amount"));
	sdAmount = sdAmount || parseFloat($sd.find(".amount").data("amount"));

	percentageAmount = Math.min( Math.round(progressAmount / goalAmount * 1000)/10, 100);

	sdPercentageAmount = Math.min( Math.round(sdAmount / goalAmount * 1000)/10, 100);

	sdMarginLeft = percentageAmount - ( 0.5 * sdPercentageAmount );
	sdMarginRight = ( 100 - percentageAmount ) - ( 0.5 * sdPercentageAmount );

	$goal.find(".amount").data("amount");
	$progress.find(".amount").data("amount");
	$sd.find(".amount").data("amount");

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

