// hesperian_mobile_init.js
// This is loaded before jquery mobile so you can set up jqm initialization.
// jquery itself is available.


// Hesperian Mobile globals
var HM = { 
  platform: "", // Android, iPhone
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
					$("div.sequence-dots",this).css("margin-top","-=10px");
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

  // Android needs some extra work to open external links in the browser,
  // rather than keeping them in the app (which tends to be buggy).
  // The links in question should be class "external-site", with
  // target "_blank", indicating they want to open in the browser.
  if(HM.platform === 'Android') {
    $("a.external-site", this).each(function() {
      var a = $(this),
        href = a.attr('href');
        
      if( a.attr('target') === '_blank') {
        a.bind('tap', function() {
          navigator.app.loadUrl(href, {openExternal: true});
          return false;
        });
      }
    });
  }
});

// deviceready will be triggered by phonegap when it is loaded.
// exactly when to call document.addEventListener is a bit obscure
// and attempting to follow the documentation directly (e.g. calling
// out of an onLoad() for the body tag, didn't get us called on Android.
// Other examples call soon after the load of phonegap.js, which in essence
// is what's happening here, and seems to work.
document.addEventListener("deviceready", function() {
      var platform;
      $("body").addClass("hm-phonegap");
      if( device && device.platform) {
        // plaform on iOS can be "iPhone Simulator"
        platform = device.platform.replace(/\s+Simulator$/, "");
        $("body").addClass("hm-phonegap-" + platform);
        HM.platform = platform;
      }
}, false);

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
