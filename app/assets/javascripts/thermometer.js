function thermometer(goalAmount, progressAmount, sdAmount, animate) {
	"use strict";

	var $thermo = $("#thermometer"),
			$progress = $(".progress", $thermo),
			$goal = $(".goal", $thermo),
			percentageAmount;

	goalAmount = goalAmount || parseFloat($goal.text()),
	progressAmount = progressAmount || parseFloat($progress.text()),
	percentageAmount = Math.min( Math.round(progressAmount / goalAmount * 1000)/10, 100);
	$goal.find(".amount").text(goalAmount);
	$progress.find(".amount").text(progressAmount);

	$progress.find(".amount").hide();
	if (animate !== false) {
		$progress.animate({
			"width": percentageAmount + "%"
		}, 1200, function(){
			$(this).find(".amount").fadeIn(500);
		});
	} else {
		$progress.css({
			"height": percentageAmount + "%"
		});
		$progress.find(".amount").fadeIn(500);
	}
}

