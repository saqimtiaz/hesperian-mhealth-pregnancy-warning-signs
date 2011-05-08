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

# JQuery mobile version (minus .js / .css extension)
JQM=jquery.mobile-1.0a4.1.min

# JavaScript sources, in order of page inclusion
JSOBJ=jslib/jquery-1.5.1.min.js  jslib/jquery.mobile/$(JQM).js jslib/hesperian_mobile.js

.PHONY: all html

all: html 
	
html: 
	@-mkdir html
	# Copy the raw html source from the src directory
	./bin/copyfiles.pl src html
	./bin/concatinate_html.pl src > html/index.html 
	# Create an .htaccess file with the right mime-type for a manifest
	echo "AddType text/cache-manifest .manifest" > html/.htaccess
	# Merge the javascript into one .js file
	cat $(JSOBJ) > html/hesperian_mobile.js
	# Put the jquery mobile css and images into a jquery.mobile directory
	@-mkdir html/jquery.mobile
	cp jslib/jquery.mobile/$(JQM).css html/jquery.mobile/
	cp -Rf jslib/jquery.mobile/images html/jquery.mobile/
	# Create a manifest
	./bin/create_manifest.pl html > html/cache.manifest

clean:
	@- rm -R html
