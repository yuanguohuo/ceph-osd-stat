#!/usr/bin/perl

use strict;
use warnings;
use Carp;                      #croak

use File::Tail;
use Getopt::Std;


sub usage()
{
  print "Usage: osd-stat.pl -o <osd> -p <period> -r <read-threshold> -w <pri-write-threshold> -s <sub-write-threshold> -h\n";
  print "       -o osd:                 the osd to monitor, like osd.x\n";
  print "       -p period:              period of time to report, in seconds\n";
  print "       -r read-threshold:      don't take read ops that takes less than this time (in micro-seconds) into account\n";
  print "       -w pri-write-threshold: don't take pri-write ops that takes less than this time (in micro-seconds) into account\n";
  print "       -s sub-write-threshold: don't take sub-write ops that takes less than this time (in micro-seconds) into account\n";
  print "       -h print this help message\n";
}

my %opts = ();
getopts('o:p:r:w:s:h',\%opts);

my $osd              = undef;
my $period           = 60;
my $read_threshold   = 100000;
my $pWrite_threshold = 200000;
my $sWrite_threshold = 150000;

foreach my $k (keys %opts)
{
  if($k eq "o")
  {
    $osd = $opts{$k};
  }
  elsif($k eq "p")
  {
    $period = $opts{$k};
  }
  elsif($k eq "r")
  {
    $read_threshold = $opts{$k};
  }
  elsif($k eq "w")
  {
    $pWrite_threshold = $opts{$k};
  }
  elsif($k eq "s")
  {
    $sWrite_threshold = $opts{$k};
  }
  elsif($k eq "h")
  {
    usage();
    exit 0;
  }
}

if (defined $osd)
{
  unless ($osd =~ "osd.[0-9]+")
  {
    print "ERROR: param <osd> should be in osd.x format\n";
    usage(); 
    exit 1;
  }

  my $osd_id = `echo $osd | sed -e 's/osd.//'`;
  chomp $osd_id;
  my $tmpout = `ps -ef | grep "ceph-osd -i $osd_id" | grep -v grep 2> /dev/null`;
  if( $tmpout eq "" )
  {
    print "ERROR: $osd is not running on this host\n";
    usage(); 
    #exit 1;
  }
}
else
{
  my $osd_id = `ps -ef | grep -o "ceph-osd -i [0-9][0-9]*" | cut -d ' ' -f 3 | head -n 1`;
  if( $osd_id eq "" )
  {
    print "ERROR: there seems no OSD running on this host\n";
    usage(); 
    exit 1;
  }
  $osd="osd.".$osd_id;
}

print $osd, "\n";
print $period, "\n";
print $read_threshold,"\n";
print $pWrite_threshold, "\n";
print $sWrite_threshold, "\n";
