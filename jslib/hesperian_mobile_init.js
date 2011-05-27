// hesperian_mobile_init.js
// This is loaded before jquery mobile so you can set up jqm initialization.
// jquery itself is available.

// iPhone / Mobile Safari workarounds
function isiPhone(){
    return ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)));
};




//populate sequence-bar div and highlight appropriate circle
$("div.[data-role=page]").live('pagebeforecreate',function(event){
	$("div.sequence-bar").each(function(index) {
		var seq_length = $(this).attr("seq-length");
		var seq_position = $(this).attr("seq-position");
		var pos = 0;
		while (pos < seq_length) {
			if (pos + 1 == seq_position) {
				$("div.sequence-dots",this).append('<div class="circle active"></div>');
			} else {
				$("div.sequence-dots",this).append('<div class="circle"></div>');
			}
			pos++;
		}
	});	
});

// jquery mobile configuration
