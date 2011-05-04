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

all: web
	
web: 
	@-mkdir html
	# Copy the raw html source from the src directory
	cp -R src/* html
	# Create an .htaccess file with the right mime-type for a manifest
	echo "AddType text/cache-manifest .manifest" > html/.htaccess
	# Merge the javascript into one .js file
	cat $(JSOBJ) > html/hesperian_mobile.js
	# Put the jquery mobile css and images into a jquery.mobile directory
	@-mkdir html/jquery.mobile
	cp jslib/jquery.mobile/$(JQM).css html/jquery.mobile/
	cp -Rf jslib/jquery.mobile/images html/jquery.mobile/
	# Create a manifest
	find html -type f -name \?\*.\* -exec echo {} \;\
		 | sed -e 's/^html\///' >> filelist
	echo "CACHE MANIFEST" > html/cache.manifest
	echo "#" `date` >> html/cache.manifest
	grep -v cache.manifest filelist >> html/cache.manifest
	@rm filelist

clean:
	@- rm -R html
