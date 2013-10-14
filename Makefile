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
# For building the mobile app itself (rather than just the html)
# use the gapbuild target. You'll need to set LOCALIZATION to the proper
# localized source to use. Output will be found in safe-birth-$(LOCALIZATION)

# Build number.
BUILD=0018

# Main source directory - retarget for localized builds
# Available localizations: en es
LOCALIZATION ?= en
SRC=localizations/$(LOCALIZATION)
GAPDEST=safe-birth-$(LOCALIZATION)

SITEBUILDDIR=site/www/archive/$(BUILD)

JINJAFY=$(abspath ./bin/jinjafy.py)
TMP=$(abspath ./tmp)

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
gapbuild: DESTDIR ?= $(GAPDEST)
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
	cp -R $(SRC)/images $(DESTDIR)/images
	@mkdir -p $(TMP)/rendered
	# render each html file with jinja
	cd $(SRC)/;for filename in *.html;do echo "{}" | $(JINJAFY) $$filename > $(TMP)/rendered/$$filename;done
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
	cat $(SRC)/$(CSS).css >> $(DESTDIR)/hesperian_mobile.css
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

gapbuild: htmldest
	cp $(SRC)/config.xml $(DESTDIR)
	cp -R phonegap/icons $(DESTDIR)
	cp -R phonegap/splash $(DESTDIR)
	# Create a dummy string localization file - Apple app store UI looks for these to report language support
	mkdir -p $(DESTDIR)/locales/$(LOCALIZATION)
	echo "\"DummyKey\" = \"Dummyvalue\";"  > $(DESTDIR)/locales/$(LOCALIZATION)/local.strings

# 
gapcommit:
	rm -R ../$(GAPDEST)/*
	cp -R $(GAPDEST)/* ../$(GAPDEST)
	(cd ../$(GAPDEST); git add -A; git commit -m "updated build")
  
clean:
	@- rm -R html
	@- rm -R safe-birth-??
	@- rm -R $(TMP)

release:
	mkdir -p $(SITEBUILDDIR)/app
	make DESTDIR=$(SITEBUILDDIR)/app html
	(cd phonegap/iOS/; make OUTDIR=../../$(SITEBUILDDIR) BUILD=$(BUILD) release)
	(cd site; make BUILD=$(BUILD) www)

site-deploy:
	(cd site; make deploy)

