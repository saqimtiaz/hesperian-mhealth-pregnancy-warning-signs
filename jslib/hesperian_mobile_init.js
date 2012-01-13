// hesperian_mobile_init.js
// This is loaded before jquery mobile so you can set up jqm initialization.
// jquery itself is available.


// Hesperian Mobile globals
var HM = { 
  // Return the content section for the given jQuery page object,
  // for a transition from previousSectionID
  testForPageSectionMatch: function(pageID, sectionList) {
    var i;
    for(i = 0; i < sectionList.length; i++) {
      if( (sectionList[i] === pageID) || (sectionList[i] === '*')) // Glob matches all.
        return true;
    }
    
    return false;
  },
  getContentSectionForPage: function(page, previousSectionID)
  {
    var pageID = page.attr('id');
    var section = pageID; // default to self id.
    if( pageID in HM.contentsections) {
      sectionList = HM.contentsections[pageID];
      // Keep the current section, if allowed by the new page, otherwise use new page default.
      if( sectionList.length > 0) {
        section = (previousSectionID && this.testForPageSectionMatch(previousSectionID, sectionList))
                  ? previousSectionID
                  : sectionList[0];
      }
    }
    //console.log("getContentSectionForPage("+pageID + ", " + previousSectionID + ") returns: " + section);
    return section;
  },
  
  // Cache of our current section (for the "up" button). KLOOGE: this will only work in the single page app -
  // on the load of a new html page, this will be reset, losing history.
  currentSection: null
};

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
				if (seq_length == 0) {
					$("div.sequence-dots",this).css("margin-top","-=8px");
					return;
				}
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

$("div:jqmData(role='page')").live("pagebeforeshow",function(event, ui) {
	var page = $(this);
  HM.currentSection =  HM.getContentSectionForPage(page, HM.currentSection);
  $('.upbutton', page).hide();
  $('[upid='+HM.currentSection+']', page).show();
});

$("div:jqmData(role='page')").live("pageshow",function(event) {
	if ($(this).attr("swipe") == "true") {
		var el = $("div.sequence-bar-bottom",this);
	/*	if ( $(window).scrollTop() + $(window).height() > el.offset().top ) {
			console.log("in view");
		} else {
			console.log("hidden");
		}
	*/
	//console.log($(document).height() - $(window).height() - $("div.ui-header",this).height() - $("div.sequence-bar:first",this).height());
		if ( $(document).height() - $(window).height() - $("div.ui-header",this).height() - $("div.sequence-bar:first",this).height() + 20 < 0) {
		//	console.log(el);
			el.hide();
		}
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
