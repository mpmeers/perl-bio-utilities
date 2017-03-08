#!usr/bin/perl

use strict;

#This script is meant to take the mean of a desired factor from an experimental subset,
#then simulate a mean from randomized sampling of the same number of rows in the experimental
#input for a user-defined number of simulations.  It takes four entries: an experimental list
#file, a full list file (where the experimental list is a subset defined by the full list),
#the index to be iterated over, and the number of times to simulate from the full list.

#In version 2.0, if a fifth argument is included, the program will output both the vector of
#experimental values in the format <argument>.countvector.txt, and the vector of simulated
#means in the format <argument>.meanvector.txt

my @exp;
my $index = $ARGV[2];
my $sum = 0;
my $counts = 0;
open(BUFFER, $ARGV[0]);
while(my $line = <BUFFER>){
	chomp($line);
	my @fields = split("\t", $line);
	$exp[$counts] = $fields[$index];
	if($fields[$index] =~ /^[0-9,.E-]+$/ ){
		$sum = $sum + $fields[$index];
		$counts++;
	}
}
my $mean = $sum/$counts;
print "Experimental mean: $mean\nCounts: $counts\n";
if($ARGV[4]){
	open(OUT, ">>$ARGV[4].countvector.txt");
	my $j = 0;
	my $length = @exp;
	while($j < $length){
		print OUT "$exp[$j]\n";
		$j++;
	}
	print OUT "$exp[$length]\n";
	close(OUT);
}
$sum = 0;

my @list;
my @templist;
my $i = 0;
open(BUFFER, $ARGV[1]);
while(my $line2 = <BUFFER>){
	chomp($line2);
	my @fields2 = split("\t", $line2);
	@{$list[$i]} = @fields2;
	$i++;
}

my $iterations = $ARGV[3];
my $k = 0;
my $l = 0;
my $megasum = 0;
my @means;
while($k < $iterations){
	$l = 0;
	if($k%100 == 0){
		print "Finished $k simulations...\n";
	}
	@templist = @list;
	my $length2 = @templist;
	$sum = 0;
	LINE: while($l < $counts){
		my $m = int(rand($length2));
		if($templist[$m][$index] =~ /^[0-9,.E-]+$/ ){
			$sum = $sum + $templist[$m][$index];
			splice(@templist, $m, 1);
			$length2 = @templist;
			$l++;
		}else{
			next LINE;
		}
	}
	my $newmean = $sum/$l;
	$means[$k] = $newmean;
	$megasum = $megasum + $newmean;
	$newmean = 0;
	$k++;
}
my $totalmean = $megasum/$iterations;
my $ratio = $mean/$totalmean;
print "Simulated mean: $totalmean\nIterations: $iterations\nRatio: $ratio\n";
if($ARGV[4]){
	open(OUT, ">>$ARGV[4].meanvector.txt");
	my $n = 0;
	my $length2 = @means;
	while($n < $length2){
		print OUT "$means[$n]\n";
		$n++;
	}
	print OUT "$means[$length2]\n";
	close(OUT);
}
