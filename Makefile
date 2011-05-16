# Makefile for creating the hesperian mobile web application
#
# The raw html source lives in the src directory.
# javacscript lives in in the jslib directory.
#
# We'll assemble the web-app in the html directory (make web).
# This will concatinate the needed .js files into one hesperian_mobile.js file
# and create an html5 cache.manifest file (along with a .htaccess which will
# serve the correct content type for the manifest.
#

# JQuery (minus .js / .css extension)
JQUERY ?= jquery-1.5.1.min
# JQuery mobile version (minus .js / .css extension)
JQM ?= jquery.mobile-1.0a4.1.min
# phonegap version (minus .js / .css extension)
PHONEGAP ?= phonegap.0.9.5.min

# JavaScript sources, in order of page inclusion
JSOBJ=jslib/$(JQUERY).js  jslib/hesperian_mobile_init.js jslib/jquery.mobile/$(JQM).js jslib/hesperian_mobile.js

# phonegap needs addional javascript
phonegap: JSOBJ += jslib/$(PHONEGAP).js

# destination directory where we will assemble the app
html: DESTDIR = html
phonegap: DESTDIR = phonegap/www


.PHONY: all html phonegap

all: html 

htmldest:
	@-rm -R $(DESTDIR)
	@-mkdir $(DESTDIR)
	# Copy the raw html source from the src directory
	./bin/copyfiles.pl src $(DESTDIR)
	./bin/concatinate_html.pl src > $(DESTDIR)/index.html 
	# Merge the javascript into one .js file
	cat $(JSOBJ) > $(DESTDIR)/hesperian_mobile.js
	# Put the jquery mobile css and images into a jquery.mobile directory
	@mkdir $(DESTDIR)/jquery.mobile
	cp jslib/jquery.mobile/$(JQM).css $(DESTDIR)/jquery.mobile/
	cp -Rf jslib/jquery.mobile/images $(DESTDIR)/jquery.mobile/

manifest:
	# Create a manifest
	./bin/create_manifest.pl  $(DESTDIR) >  $(DESTDIR)/cache.manifest
	echo "AddType text/cache-manifest .manifest" >  $(DESTDIR)/.htaccess
	
html: htmldest manifest

phonegap: htmldest

clean:
	@- rm -R html
	@- rm -R phonegap/www/*
