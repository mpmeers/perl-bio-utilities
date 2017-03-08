#!usr/bin/perl

use strict;

#This script is intended to randomly select a user-defined number of lines from a user-provided file

my @list;
my $i = 0;
open(BUFFER, $ARGV[0]);
while(my $line = <BUFFER>){
	chomp($line);
	my @fields = split("\t", $line);
	@{$list[$i]} = @fields;
	$i++;
}

my $counts = $ARGV[1];
my $l = 0;
my $length2 = @list;
while($l < $counts){
	my $m = int(rand($length2));
	my $n = 0;
	my $length = @{$list[$m]};
	while($n < $length){
		print "$list[$m][$n]\t";
		$n++;
	}
	print "$list[$m][$n]\n";
	splice(@list, $m, 1);
	$length2 = @list;
	$l++;
}
