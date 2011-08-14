// hesperian_mobile_init.js
// This is loaded before jquery mobile so you can set up jqm initialization.
// jquery itself is available.

// iPhone / Mobile Safari workarounds
function isiPhone(){
    return ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)));
};

$(document).bind("mobileinit", function(){
	$.mobile.defaultPageTransition = "none";
});

$("div:jqmData(role='page')").live('pagebeforecreate',function(event){
	if ($(this).attr("swipe") == "true") {
		var html = "";
		$("div.sequence-bar",this).each(function(index) {
			if (html == "") {
				var seq_length = $(this).attr("seq-length");
				var seq_position = $(this).attr("seq-position");
				var pos = 0;
				while (pos < seq_length) {
					if (pos + 1 == seq_position) {
						html += '<div class="circle active"></div>';
					} else {
						html += '<div class="circle"></div>';
					}
					pos++;
				}
			}
			$("div.sequence-dots",this).append(html);
		});
	}
});

/* *** Commenting out swiping code
//binds swipe events to the specified elements and maps them to clicks on the previous and next links based on them having the appropriate class
function swipeToClick(el) {
	$(el).bind("swiperight swipeleft", function(event) {
		event.preventDefault();
		if (event.type == "swipeleft") {
			var href = $("a.seq-nav-button-right:first",this).attr("href");
			if (href != "javascript:;")
				$.mobile.changePage(href,"none");
		}
		else if (event.type == "swiperight") {
			var href = $("a.seq-nav-button-left:first",this).attr("href");
			if (href != "javascript:;")
				$.mobile.changePage(href,"none");
		}		
	});
}

//swiping would need to be selectively added to pages where we wanted it
$("div:jqmData(role='page')").live("pagecreate",function(event) {
	var page = $(this);
	//pass page to bind swipe after filtering it for pages containing a div with class sequence bar, this identifies that swiping is to be enabled.
	if (page.attr("swipe") == "true")
		swipeToClick(page);
});
** end swiping code */

// jquery mobile configuration
