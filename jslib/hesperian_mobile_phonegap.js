	var onDeviceReady = function() {
		$("div:jqmData(role='page')").live("pageshow",function(event) {
			if (window.PhoneGap) {
				if (device != undefined) {
					if (device.platform == "Android") {
						$("a.ui-btn-left.hm-back-button.hm-nav-button",this).hide();
						$("body").addClass("hm-android");
					} else if (device.platform == "iPhone") {
						$("body").addClass("hm-ios");
					}
				
				}		
			}
		});
	};
	
	$(document).ready(function() {
		document.addEventListener("deviceready", onDeviceReady, true);
	});
