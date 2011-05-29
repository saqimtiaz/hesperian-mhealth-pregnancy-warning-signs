#!/usr/bin/perl -w
#
# Assemble the html/css and images for distribution.
# 
# This will combine the various html files into one jquery mobile
# style page (index.html)
#
# Creation of the combined hesperian_moble.js is not done by
# this script. This is just for creaton of the plain-old html.
#

use strict;
my $srcdir = shift;
chdir($srcdir) if $srcdir;

# Read the html files.
my @files = glob("*.html");

# move 'index.html' to the head of the list
my( $index )= grep { $files[$_] eq 'index.html' } 0..$#files;
@files[0,$index] = @files[$index,0];

# We'll collect various information about the files
my %fileInfo = ();

my $preamble = ""; # Everything up to the <body> tag in 'index.html'
my $body = ""; # The concatenated bodies of the various pages
my $postamble = ""; # Everything to the end from the </body> tag of 'index.html'

foreach my $file (@files) {
  # Slurp the text
  open( my $fh, $file ) or die "Can't open $file\n";
  my $text = do { local( $/ ) ; <$fh> } ;

  $text =~ s/(^.*<body>)//si;
  $preamble = $1 unless $preamble; # grab the preamble from the first file

  $text =~ s/(<\/body>.*$)//si;
  $postamble = $1 unless $postamble; # grab the postamble from the first file
  
  $fileInfo{$file}{'text'} = $text; # remember the text

  $body .= $text; # concatinate

  # Remember the id of the first jquery mobile page
  $text =~ /<div data-role=\"page\" id=\"([^"]*)">/s;
  my $firstId = $1;
  $fileInfo{$file}{'firstId'} = $firstId;
}


# Fix links in the body: link to page.html now may be a link
# to a jquery mobile div with data-role="page"
foreach my $f (@files) {
 my $id = $fileInfo{$f}{'firstId'};
 # look for link to subpages e.g. foo.html#SubPage
 $body =~ s/<a href=\"$f#([^"]*)"([^>]*)/<a href=\"#$1"$2/mig;
 # look for link to external pages e.g. foo.html
 $body =~ s/<a href=\"$f[^>]*/<a href=\"#$id"/mig;
}

# For jquery mobile style links "#PageID", the rel="external" needs be exised.
$body =~ s/<a href=\"#([^>]*)rel=\"external\"([^>]*)/<a href=\"#$1$2/mig;

print $preamble;
print $body;
print $postamble;

exit 0;
