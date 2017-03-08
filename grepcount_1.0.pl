#!usr/bin/perl

use strict;

#This script is intended to count the number of instances of a user-defined string in a
#single field in each line of a user-provided file, which is useful for identifying the
#number of short sequence motifs in a longer sequence, for instance.

die "Three entries required: file, motif and column.  Aborting.\n" unless($ARGV[0] && $ARGV[1] && $ARGV[2]);
my $motif = $ARGV[1];
my $column = $ARGV[2];
my $count = 0;
open(BUFFER, $ARGV[0]);
while(my $line = <BUFFER>){
	chomp($line);
	$count = 0;
	my @fields = split("\t", $line);
	$count++ while $fields[$column] =~ /$motif/g;
	print "$line\t$count\n";
}
close(BUFFER);
