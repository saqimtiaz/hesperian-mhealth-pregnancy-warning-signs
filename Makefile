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
# Directory in jslib containing JQM files
JQMDIR ?= jquery.mobile
# phonegap version (minus .js / .css extension)
PHONEGAP ?= phonegap.0.9.5.min

# JavaScript sources, in order of page inclusion
JSOBJ=jslib/$(JQUERY).js  jslib/hesperian_mobile_init.js jslib/$(JQMDIR)/$(JQM).js jslib/hesperian_mobile.js

# css files to @import in the main hesperian_mobile.css
CSSIMPORT ?= jquery.mobile/$(JQM).css

# phonegap needs addional javascript
phonegap: JSOBJ += jslib/$(PHONEGAP).js

# destination directory where we will assemble the app
html: DESTDIR = html
phonegap: DESTDIR = phonegap/www

# Combine all the html into one file?
COMBINEHTML ?= YES

.PHONY: all html phonegap

all: html 

htmldest:
	@-rm -R $(DESTDIR)
	@-mkdir $(DESTDIR)
	# Copy the raw html source from the src directory
	cp -R src/images $(DESTDIR)/images
	@rm -fr src/rendered
	@mkdir src/rendered
	# render each html file with jinja
	cd src/;for filename in *.html;do ../bin/jinjafy.py $$filename > rendered/$$filename;done
ifeq ("YES","$(COMBINEHTML)")
	./bin/concatinate_html.pl src/rendered > $(DESTDIR)/index.html
else
	cp  src/rendered/* $(DESTDIR)
endif
	# Merge the javascript into one .js file
	cat $(JSOBJ) > $(DESTDIR)/hesperian_mobile.js
	# create the main ccs file
	for f in $(CSSIMPORT); do echo @import url\(\'$$f\'\)\; >> $(DESTDIR)/hesperian_mobile.css; done ;
	cat src/hesperian_mobile.css >> $(DESTDIR)/hesperian_mobile.css
	# Put the jquery mobile css and images into a jquery.mobile directory
	@mkdir $(DESTDIR)/jquery.mobile
	cp jslib/$(JQMDIR)/$(JQM).css $(DESTDIR)/jquery.mobile/
	cp -Rf jslib/$(JQMDIR)/images $(DESTDIR)/jquery.mobile/

manifest:
	# Create a manifest
	./bin/create_manifest.pl  $(DESTDIR) >  $(DESTDIR)/cache.manifest
	echo "AddType text/cache-manifest .manifest" >  $(DESTDIR)/.htaccess
	
html: htmldest manifest

phonegap: htmldest

fetch-jqm-latest:
	# fetch and extract the latest daily build of JQM
	@- rm -R jslib/latest
	curl http://code.jquery.com/mobile/latest/jquery.mobile.zip > jqm-latest.zip
	mkdir jslib/latest
	unzip jqm-latest.zip -d jslib/latest
	rm jqm-latest.zip
	# To build with latest: make JQUERY=jquery-1.6.1.min JQM=jquery.mobile.min JQMDIR=latest/jquery.mobile

clean:
	@- rm -R html
	@- rm -R phonegap/www/*
	@- rm -R src/rendered
	@- rm -R jslib/latest
