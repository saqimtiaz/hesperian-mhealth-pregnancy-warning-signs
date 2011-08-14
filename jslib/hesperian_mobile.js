// hesperian_mobile.js

// Override swipe verticalDistanceThreshold (75) and friends to be less sensitive.
$.event.special.swipe.verticalDistanceThreshold = 125; // Swipe vertical displacement must be less than this.
$.event.special.swipe.scrollSupressionThreshold= 20; // More than this horizontal displacement, and we will suppress scrolling.
$.event.special.swipe.durationThreshold= 1000; // More time than this, and it isn't a swipe.
$.event.special.swipe.horizontalDistanceThreshold= 60;  // Swipe horizontal displacement must be more than this.

function getHiddenHeight() {
		return $(document).height() - $(document).scrollTop() - $(window).height();
}

/* start of code for displaying an indicator that you can scroll to see more content */

//check jqm fixed header code for a better way of doing this
function setBottomPosition (el) {
	$(el).css("top",window.innerHeight + window.scrollY - 44 + "px");
}

function showKeepReadingText(id) {
	var hidden = getHiddenHeight();
	//alert(hidden);
	if (hidden > 20) {
		setBottomPosition(id);
		$(id).show();
		$(id).fadeIn("slow");
	} else {
		$(id).hide();
	}
}

$("div:jqmData(role='page')").live("pageshow",function(event) {
	showKeepReadingText("#hm-keepreading");
});

$("div:jqmData(role='page')").live("pagehide",function(event) {
	$("#hm-keepreading").hide();
});

$(window).bind("scrollstart",function(event){
	$("#hm-keepreading").hide();
});

$(window).bind("scrollstop",function(event){
	showKeepReadingText("#hm-keepreading");
});
