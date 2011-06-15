// HesperianMobile.js

// Plugin for iOS Hesperian Mobile application specific functionality.

(function () {

var HesperianMobile = function() { 

};


HesperianMobile.prototype.init = function(types, success, fail) {
    return PhoneGap.exec("HesperianMobile.init", GetFunctionName(success), GetFunctionName(fail), types);
};


PhoneGap.addConstructor(function() 
{
  if(!window.plugins)
  {
    window.plugins = {};
  }
  window.plugins.HesperianMobile = new HesperianMobile();
});

function Startup() {
}

/**
* Hide load indicator
*/
Startup.prototype.hideLoadIndicator = function() {
    PhoneGap.exec("Startup.hideActivityView");
};

/**
* Hide startup screen and bring web view to front.
*/
Startup.prototype.hideStartupScreen = function() {
    PhoneGap.exec("Startup.hideImageView");
    PhoneGap.exec("Startup.bringWebViewToFront");
};


PhoneGap.addConstructor(function()
{
	if(!window.plugins)
	{
		window.plugins = {};
	}
    window.plugins.startup = new Startup();
});


})();


// Call the plugin's init function when the device is ready.
$(document).ready(function() {
  document.addEventListener("deviceready", 
  function() {
    window.plugins.HesperianMobile.init();
    window.plugins.Startup.hideStartupScreen();
  }
  , false);
});




