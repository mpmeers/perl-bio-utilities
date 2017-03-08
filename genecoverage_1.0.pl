#!usr/bin/perl

use strict;

#This script is intended to generate a .bed file reporting all regions in the genome that are covered
#by at least one gene.  It takes an input .bed file containing the coordinates for all genes in the genome.

my $i = 0;
my $storedstart;
my $storedstop;
my $storedchr;
open(BUFFER, $ARGV[0]);
while(my $line = <BUFFER>){
	chomp($line);
	my @fields = split("\t", $line);
	if($fields[0] eq $storedchr){
		if($fields[1] < $storedstop){
			if($fields[2] > $storedstop){
				$storedstop = $fields[2];
			}
		}else{
			print "$storedchr\t$storedstart\t$storedstop\n";
			$storedchr = $fields[0];
			$storedstart = $fields[1];
			$storedstop = $fields[2];
		}
	}else{
		print "$storedchr\t$storedstart\t$storedstop\n";
		$storedchr = $fields[0];
		$storedstart = $fields[1];
		$storedstop = $fields[2];
	}
}
print "$storedchr\t$storedstart\t$storedstop\n";
