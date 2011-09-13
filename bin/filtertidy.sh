#!/bin/sh

# tidy gives numerous warnings on certain constructs. We will suppress them
# so as no to drown out other perhaps more importan errors.
#
# Warning: <img> lacks "alt" attribute
# yes - but adding alt's will be a big job.
#
# Warning: <div> proprietary attribute "data-theme"
# JQM uses proprietary attributes a whole lot.
#

grep -v "lacks \"alt\" attribute" | grep -v "proprietary attribute" | grep -v \
"attribute \"href\" lacks value"
