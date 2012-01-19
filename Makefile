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

BUILD=0017
SITEBUILDDIR=site/www/archive/$(BUILD)

TMP=./tmp

JSMIN ?= .min
# JQuery (minus .js / .css extension)
JQUERY ?= jquery-1.6.4$(JSMIN)
# JQuery mobile version (minus .js / .css extension)
JQM ?= jquery.mobile-1.0$(JSMIN)
# Directory in jslib containing JQM files
JQMDIR ?= jquery.mobile-1.0
# phonegap version (minus .js / .css extension)
PHONEGAP ?= phonegap-1.2.0

# JavaScript sources, in order of page inclusion
JSOBJ ?= jslib/$(JQUERY).js  jslib/hesperian_mobile_init.js jslib/contentsections.js jslib/$(JQMDIR)/$(JQM).js jslib/hesperian_mobile.js

# Main css file in src
CSS ?= hesperian_mobile
# css files to @import in the main hesperian_mobile.css
CSSIMPORT ?= jquery.mobile/$(JQM).css

# phonegap needs addional javascript
phonegap: JSOBJ += jslib/$(PHONEGAP).js phonegap/Plugins/HesperianMobile.js

# destination directory where we will assemble the app
html: DESTDIR ?= html
phonegap: DESTDIR ?= phonegap/iOS/www

# Combine all the html into one file?
COMBINEHTML ?= YES

.PHONY: all html phonegap

all: html 

htmldest:
	@rm -fr $(TMP)
	-rm -R $(DESTDIR)
	@-mkdir $(DESTDIR)
	# Copy the raw html source from the src directory
	cp -R src/images $(DESTDIR)/images
	@mkdir -p $(TMP)/rendered
	# render each html file with jinja
	cd src/;for filename in *.html;do echo "{}" | ../bin/jinjafy.py $$filename > ../$(TMP)/rendered/$$filename;done
ifeq ("YES","$(COMBINEHTML)")
	@-rm tidy.log
	./bin/concatinate_html.pl $(TMP)/rendered | tee $(TMP)/index-pretidy.html | ./bin/tidy.sh > $(DESTDIR)/index.html
	./bin/filtertidy.sh
else
	cp  $(TMP)/rendered/* $(DESTDIR)
endif
	# Merge the javascript into one .js file
	for f in $(JSOBJ); do cat $$f >> $(DESTDIR)/hesperian_mobile.js; done;
	# create the main ccs file
	for f in $(CSSIMPORT); do echo @import url\(\'$$f\'\)\; >> $(DESTDIR)/hesperian_mobile.css; done ;
	cat src/$(CSS).css >> $(DESTDIR)/hesperian_mobile.css
ifneq ("","$(JQM)")
	# Put the jquery mobile css and images into a jquery.mobile directory
	@mkdir $(DESTDIR)/jquery.mobile
	cp jslib/$(JQMDIR)/$(JQM).css $(DESTDIR)/jquery.mobile/
	cp -Rf jslib/$(JQMDIR)/images $(DESTDIR)/jquery.mobile/
endif

manifest:
	# Create a manifest
	./bin/create_manifest.sh  $(DESTDIR) >  $(DESTDIR)/cache.manifest
	echo "AddType text/cache-manifest .manifest" >  $(DESTDIR)/.htaccess
	
html: htmldest manifest

clean-phonegap:
	@- rm -R phonegap/iOS/www/*

phonegap: clean-phonegap htmldest

fetch-jqm-latest:
	# fetch and extract the latest daily build of JQM
	@- rm -R jslib/latest
	curl http://code.jquery.com/mobile/latest/jquery.mobile.zip > jqm-latest.zip
	mkdir jslib/latest
	unzip jqm-latest.zip -d jslib/latest
	rm jqm-latest.zip

clean:
	@- rm -R html
	@- rm -R phonegap/iOS/www/*
	@- rm -R $(TMP)
	@- rm -R jslib/latest

release:
	mkdir -p $(SITEBUILDDIR)/app
	make DESTDIR=$(SITEBUILDDIR)/app html
	(cd phonegap/iOS/; make OUTDIR=../../$(SITEBUILDDIR) BUILD=$(BUILD) release)
	(cd site; make BUILD=$(BUILD) www)

site-deploy:
	(cd site; make deploy)

# Special targets for prototype builds
profile-html:
	make JSMIN="" html

# Builds with the latests version of JQM
latest-html:
	make JQUERY=jquery-1.6.1.min JQM=jquery.mobile.min JQMDIR=latest/jquery.mobile phonegap
latest-phonegap:
	make JQUERY=jquery-1.6.1.min JQM=jquery.mobile.min JQMDIR=latest/jquery.mobile html
dev-phonegap:
	make JQUERY=jquery-1.6.1.min JQM=jquery.mobile JQMDIR=jquery.mobile.latest/jquery.mobile/ phonegap

# Builds without jquery or JQM - only our own explicit jslib/standalone.js
nojq-html:
	make JQUERY="" JQM="" JSOBJ=jslib/standalone.js COMBINEHTML="NO" html
nojq-phonegap:
	make JQUERY="" JQM="" JSOBJ=jslib/standalone.js COMBINEHTML="NO" phonegap
