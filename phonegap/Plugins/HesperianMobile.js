// HesperianMobile.js

// Plugin for iOS Hesperian Mobile application specific functionality.

(function () {

var HesperianMobile = function() { 

};


HesperianMobile.prototype.OnDeviceReady = function(types, success, fail) {
    return PhoneGap.exec("HesperianMobile.OnDeviceReady", GetFunctionName(success), GetFunctionName(fail), types);
};


PhoneGap.addConstructor(function() 
{
  if(!window.plugins)
  {
    window.plugins = {};
  }
  window.plugins.HesperianMobile = new HesperianMobile();
});

})();


// Call the plugin's init function when the device is ready.
$(document).ready(function() {
  document.addEventListener("deviceready", 
  function() {
    window.plugins.HesperianMobile.OnDeviceReady();
  }
  , false);
});




