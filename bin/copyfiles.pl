#!/usr/bin/perl -w
#

use strict;
use File::Copy;

my ($srcdir, $destdir) = (shift, shift);

# Copy the css files
my @css = glob("$srcdir/*.css");
foreach my $f (@css) {
  copy($f, $destdir);
}

#Copy the images directory
`cp -R $srcdir/images $destdir`;

exit 0;
