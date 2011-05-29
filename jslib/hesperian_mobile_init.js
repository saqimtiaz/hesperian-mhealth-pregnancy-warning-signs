// hesperian_mobile_init.js
// This is loaded before jquery mobile so you can set up jqm initialization.
// jquery itself is available.

// iPhone / Mobile Safari workarounds
function isiPhone(){
    return ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)));
};

$("div:jqmData(role='page')").live('pagebeforecreate',function(event){

	$("div.sequence-bar",this).each(function(index) {
		var seq_length = $(this).attr("seq-length");
		var seq_position = $(this).attr("seq-position");
		var pos = 0;
		//$("div.sequence-dots",this).empty();
		while (pos < seq_length) {
			if (pos + 1 == seq_position) {
				$("div.sequence-dots",this).append('<div class="circle active"></div>');
			} else {
				$("div.sequence-dots",this).append('<div class="circle"></div>');
			}
			pos++;
		}
		$("a.seq-nav-button",this).each(function(index,el) {
			if (el.href == "javascript:;") {
				$(el).addClass("hidden").attr("disabled",true);
			}
		});

	});

});

//swiping would need to be selectively added to pages where we wanted it
$("div:jqmData(role='page')").live("pagecreate",function(e) {
	$(this).bind('swiperight swipeleft', function(e) {
		var b = $("div.ui-content",this);
		if (b.hasClass("red"))
			b.removeClass("red");
		else
			b.addClass("red");		
		});
	});

// jquery mobile configuration
