#!usr/bin/perl

use strict;

#This script is intended to merge files in a manner that can preserve the separation of a single
#field.  This can be useful, for instance, for count data in which loci are merged and counts for
#each condition remain annotated.

#Usage: perl filemerge_1.0.pl <comma-delimited list of files to be merged> <field to merge, 0-based>
#<field to preserve, 0-based>

my $merge = $ARGV[1];
my $preserve = $ARGV[2];
my @files = split(",", $ARGV[0]);
my %entries;
my $m = 0;

foreach my $i(@files){
#	print "Reading file $files[$i]...\n";
	open(BUFFER, $i);
	while(my $line = <BUFFER>){
		chomp($line);
		my @fields = split("\t", $line);
		unless(exists($entries{$fields[$merge]}{chr})){
			$entries{$fields[$merge]}{chr} = $fields[0];
			$entries{$fields[$merge]}{start} = $fields[1];
			$entries{$fields[$merge]}{stop} = $fields[2];
			$entries{$fields[$merge]}{name} = $fields[3];
			$entries{$fields[$merge]}{dot} = $fields[4];
			$entries{$fields[$merge]}{strand} = $fields[5];
		}
		$entries{$fields[$merge]}{$i} = $fields[$preserve];
	}
}
#print "Writing table...\n";
foreach my $k(keys %entries){
	print "$entries{$k}{chr}\t$entries{$k}{start}\t$entries{$k}{stop}\t$entries{$k}{name}\t$entries{$k}{dot}\t$entries{$k}{strand}\t";
	foreach my $l(@files){
		if(exists($entries{$k}{$l})){
			print "$entries{$k}{$l}\t";
		}else{
			print "0\t";
		}
	}
	print "\n";
}
