// hesperian_mobile.js

// Override swipe verticalDistanceThreshold (75) to be less sensitive.
// Note that this is a hesperian mobile specific patch to JQM - but
// should be harmless for a non-patched version.
$.event.special.swipe.verticalDistanceThreshold = 125;
