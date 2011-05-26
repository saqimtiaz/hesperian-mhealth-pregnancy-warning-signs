#!/bin/sh
find $1 -type f -name \?\*.\* -exec echo {} \; \
	| sed -e 's/^html\///' >> filelist
echo "CACHE MANIFEST"
echo "#" `date`
grep -v cache.manifest filelist
rm filelist

