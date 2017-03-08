#!usr/bin/perl

use strict;

#This script uses .sam inputs from a Start-seq experiment to determine each individual
#transcription start site in each .sam file and count the number of reads that map 
#specifically to that TSS.

#Example: scRNA_TSScount_1.0.pl <Start-seq .sam file> <read count threshold>

my $threshold;
if($ARGV[1]){
	$threshold = $ARGV[1];
}else{
	$threshold = 0;
}
my $i = 0;
my @peaks;
open(BUFFER, $ARGV[0]);
while(my $line = <BUFFER>){
	chomp($line);
	my @fields = split("\t", $line);
	if($fields[1] == 83 || $fields[1] == 99){
		if($peaks[0]){
			if($peaks[0] == $fields[2] && $peaks[1] == $fields[3]){
				$peaks[6]++;
			}else{
				if($peaks[6] > $threshold){
					if($peaks[5] eq "-"){
						$peaks[1] = $peaks[1]+26;
						$peaks[2] = $peaks[2]+26;
						$peaks[3] = "peak_$peaks[0]_$peaks[1]";
					}
					my $k = 0;
					while($k < 6){
						print "$peaks[$k]\t";
						$k++;
					}
					print "$peaks[6]\n";
				}
				$i++;
				@peaks = ();
				@peaks = ($fields[2], $fields[3], $fields[3], "peak_$fields[2]_$fields[3]", ".", ".", 1);
				if($fields[1] == 83){
					$peaks[5] = "-";
				}else{
					$peaks[5] = "+";
				}
			}
		}else{
			@peaks = ($fields[2], $fields[3], $fields[3], "peak_$fields[2]_$fields[3]", ".", ".", 1);
			if($fields[1] == 83){
				$peaks[5] = "-";
			}else{
				$peaks[5] = "+";
			}
		}
	}
}
close(BUFFER);
