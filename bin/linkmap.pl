#!/usr/bin/perl -w
use strict;
my $page = "";

my %G = ();
my @Toplevel = ();

while(<>)
{
  my $line = $_;
  chomp $line;

  if ($line =~ /data-role="page"\s+id="(\w*)"/) {
   $page = $1;
  }
  if ($line =~ /href="#(\w*)"/) {
    my $dest = $1;
    next if $dest eq 'home';
#    print "$page -> $dest\n";
    if ($page eq 'home') {
      push @Toplevel, $dest;
    } else {
      $G{$page}{$dest} = {};
    }
  }
}

my %D = ( );

sub DFS {
  my $start = shift;

  my @Q = ($start);
  $D{$start}{$start} = 0;

  while(@Q) {
   my $e = shift @Q;
   my $n = $D{$e}{$start};
   my @V = keys %{$G{$e}};
   foreach my $v(@V) {
     next if exists $D{$v}{$start};
     $D{$v}{$start} = $n + 1;
     push @Q, $v;
   }
  }
}

foreach my $h (@Toplevel) {
  DFS($h);
}

print "HM.contentsections = {\n";

my $firstdone = 0;

foreach my $d (sort keys %D) {
  my $original_d = $d;
 # normalize list of pages to first page.
 # How_to_inject_medicines_into_muscle is the base of How_to_inject_medicines_into_muscle\d
 # and How_to_injection_from_ampule\d
  $d =~ s/How_to_injection_from_ampule/How_to_inject_medicines_into_muscle/;
  $d =~ s/How_to_inject_medicines_into_muscle\d/How_to_inject_medicines_into_muscle/;

  $d =~ s/\d$/1/; # normalize list of pages to first page.

  my @V = keys %{$D{$d}};
  if(!@V) {
    warn "No big five for $d!";
  }
  @V = sort { $D{$d}{$a} <=> $D{$d}{$b}} @V;
  my $min = $D{$d}{$V[0]};
  next if 0 == $min;
  print ", " if $firstdone;
  print "$original_d:";
  my @Sections = ();
  foreach my $v (@V) {
    my $cur = $D{$d}{$v};
    last if $cur > $min;
    push @Sections, "'$v'";
    #print " $v($cur)";
  }
  print "[";
  print join(", ", @Sections); 
  print "]\n";
  $firstdone = 1;
}

print "};\n";
