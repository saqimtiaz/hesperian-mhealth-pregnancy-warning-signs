#!/usr/bin/perl -w
#
# Grab the version number from the phonegap config.xml
# and blast it into the about page version.
# 
#

use strict;
my $config = shift;
my $outfile = shift;

my $version;

open (CFG, $config) || die "Can't open $config: $!";
while(<CFG>) {
  if( m/^\s*version\s*=\s*"([^"]*)"/) {
    $version = $1;
    last;
  }
}
close(CFG);

die "No version found in $config" unless $version;

open (F, $outfile) || die "Can't open $outfile: $!";
while(<F>) {
  s|<span class="app-version">\d+.\d+.\d+</span>|<span class="app-version">$version</span>|;
  print;
}
close(F);
exit 0;
